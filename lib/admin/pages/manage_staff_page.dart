import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageStaffPage extends StatefulWidget {
  const ManageStaffPage({super.key});

  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();
  final CollectionReference staffCollection =
      FirebaseFirestore.instance.collection('staff');

  // Add new staff to Firestore
  Future<void> _addNewStaff() async {
    if (_formKey.currentState!.validate()) {
      final staffData = {
        'name': _nameController.text,
        'salary': double.parse(_salaryController.text),
        'contact': _contactController.text,
        'role': _selectedRole ?? 'Unassigned',
        'created_at': Timestamp.now(),
      };

      await staffCollection.add(staffData);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      _clearFormFields();
    }
  }

  // Edit staff details in Firestore
  Future<void> _editStaff(String id) async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameController.text,
        'salary': double.parse(_salaryController.text),
        'contact': _contactController.text,
        'role': _selectedRole ?? 'Unassigned',
      };

      await staffCollection.doc(id).update(updatedData);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      _clearFormFields();
    }
  }

  // Delete staff from Firestore
  Future<void> _deleteStaff(String id) async {
    await staffCollection.doc(id).delete();
  }

  // Show form for adding or editing staff
  void _showStaffForm({String? id, Map<String, dynamic>? staffData}) {
    if (staffData != null) {
      _nameController.text = staffData['name'];
      _salaryController.text = staffData['salary'].toString();
      _contactController.text = staffData['contact'];
      _selectedRole = staffData['role'];
    } else {
      _clearFormFields();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id != null ? 'Edit Staff' : 'Add Staff'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter name' : null,
                ),
                TextFormField(
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter salary' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter contact' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: ['Manager', 'Staff', 'Intern', 'Chashier']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (id != null) {
                  _editStaff(id);
                } else {
                  _addNewStaff();
                }
              },
              child: Text(id != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  // Clear form fields
  void _clearFormFields() {
    _nameController.clear();
    _salaryController.clear();
    _contactController.clear();
    _selectedRole = null;
  }

  String _formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myappbar,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Manage Staff'),
        backgroundColor: Colors.white10,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStaffForm(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: staffCollection.orderBy('created_at').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No staff found.'));
          }

          final staffDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: staffDocs.length,
            itemBuilder: (context, index) {
              final staff = staffDocs[index];
              final staffData = staff.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Center(
                  child: ListTile(
                    title: Text(
                      '${staffData['name']} - ${staffData['role']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salary: \$${staffData['salary'].toStringAsFixed(2)} | Contact: ${staffData['contact']}',
                          style: TextStyle(color: Colors.pink[400]),
                        ),
                        Text(
                          'Start Work: ${_formatDate(staffData['created_at'])}',
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _showStaffForm(id: staff.id, staffData: staffData);
                        } else if (value == 'Delete') {
                          _deleteStaff(staff.id);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
