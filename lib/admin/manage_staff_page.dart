import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageStaffPage extends StatefulWidget {
  const ManageStaffPage({super.key});

  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  // Sample data for staff members
  List<Staff> staffList = [
    Staff(
        id: '001',
        name: 'John Doe',
        role: 'Barista',
        salary: 350,
        contact: '012345678'),
    Staff(
        id: '002',
        name: 'Jane Smith',
        role: 'Cashier',
        salary: 300,
        contact: '098765432'),
    Staff(
        id: '003',
        name: 'Tom Clark',
        role: 'Manager',
        salary: 600,
        contact: '076543210'),
  ];

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _role = '';
  double _salary = 0;
  String _contact = '';

  // Function to add new staff
  void _addNewStaff() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        staffList.add(Staff(
            id: DateTime.now().toString(),
            name: _name,
            role: _role,
            salary: _salary,
            contact: _contact));
      });
      Navigator.pop(context); // Close the form dialog
    }
  }

  // Function to edit staff details
  void _editStaff(Staff staff) {
    setState(() {
      staff.name = _name;
      staff.role = _role;
      staff.salary = _salary;
      staff.contact = _contact;
    });
  }

  // Function to delete staff
  void _deleteStaff(Staff staff) {
    setState(() {
      staffList.remove(staff);
    });
  }

  // Dialog to add or edit staff
  void _showStaffForm({Staff? staff}) {
    if (staff != null) {
      _name = staff.name;
      _role = staff.role;
      _salary = staff.salary;
      _contact = staff.contact;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(staff != null ? 'Edit Staff' : 'Add Staff'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter name' : null,
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  initialValue: _role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter role' : null,
                  onSaved: (value) => _role = value!,
                ),
                TextFormField(
                  initialValue: _salary != 0 ? _salary.toString() : '',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter salary' : null,
                  onSaved: (value) => _salary = double.parse(value!),
                ),
                TextFormField(
                  initialValue: _contact,
                  decoration: const InputDecoration(labelText: 'Contact'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter contact' : null,
                  onSaved: (value) => _contact = value!,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.purple,
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (staff != null) {
                  _editStaff(staff); // Edit staff
                } else {
                  _addNewStaff(); // Add new staff
                }
              },
              child: Text(
                staff != null ? 'Save' : 'Add',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                disabledBackgroundColor: Colors.purple,
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Staff'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _name = '';
              _role = '';
              _salary = 0;
              _contact = '';
              _showStaffForm(); // Add staff
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Apply the gradientCategory here
        ),
        child: ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('${staff.name} - ${staff.role}'),
                subtitle: Text(
                    'Salary: \$${staff.salary.toStringAsFixed(2)} | Contact: ${staff.contact}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      _name = staff.name;
                      _role = staff.role;
                      _salary = staff.salary;
                      _contact = staff.contact;
                      _showStaffForm(staff: staff); // Edit staff
                    } else if (value == 'Delete') {
                      _deleteStaff(staff); // Delete staff
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
            );
          },
        ),
      ),
    );
  }
}

class Staff {
  String id;
  String name;
  String role;
  double salary;
  String contact;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    required this.contact,
  });
}
