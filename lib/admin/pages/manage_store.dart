// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samnang_ice_cream_roll/admin/admin_model/manage_store_model.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isLoading = false;

  // Fetch data from Firestore and display in the UI
  Stream<List<StoreIceCream>> _fetchStores() {
    return FirebaseFirestore.instance
        .collection('stores')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return StoreIceCream.fromMap(doc.id, doc.data());
            }).toList());
  }

  // Add new store to Firestore
  void _addNewStore() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final newStore = StoreIceCream(
          id: '',
          storeName: _storeNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole ?? 'staff',
        );

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('stores')
            .add(newStore.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Store added successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add store: $e")),
        );
      }

      setState(() => _isLoading = false);
      Navigator.pop(context); // Close the form dialog
    }
  }

  // Edit existing store in Firestore
  void _editStore(StoreIceCream storeicecrem) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final updatedStore = StoreIceCream(
          id: storeicecrem.id,
          storeName: _storeNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole ?? storeicecrem.role,
        );

        // Update Firestore document
        await FirebaseFirestore.instance
            .collection('stores')
            .doc(storeicecrem.id)
            .update(updatedStore.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Store updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update store: $e")),
        );
      }

      setState(() => _isLoading = false);
      Navigator.pop(context); // Close the form dialog
    }
  }

  // Delete store from Firestore
  void _deleteStore(StoreIceCream storeicecrem) async {
    try {
      await FirebaseFirestore.instance
          .collection('stores')
          .doc(storeicecrem.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Store deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete store: $e")),
      );
    }
  }

  // Dialog to add or edit staff
  void _showStoreForm({StoreIceCream? storeicecrem}) {
    if (storeicecrem != null) {
      _storeNameController.text = storeicecrem.storeName;
      _emailController.text = storeicecrem.email;
      _passwordController.text = storeicecrem.password;
      _selectedRole = storeicecrem.role;
    } else {
      _storeNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _selectedRole = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(storeicecrem != null ? 'Edit Store' : 'Add Store'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _storeNameController,
                  decoration: const InputDecoration(labelText: 'Store Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter store name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter password' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: ['admin', 'staff']
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
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (storeicecrem != null) {
                  _editStore(storeicecrem); // Edit staff
                } else {
                  _addNewStore(); // Add new staff
                }
              },
              child: Text(storeicecrem != null ? 'Save' : 'Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
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
        title: const Text('Manage Store'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStoreForm(), // Add new staff
          ),
        ],
      ),
      body: StreamBuilder<List<StoreIceCream>>(
        stream: _fetchStores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No stores found"));
          }

          final storeicecreamList = snapshot.data!;
          return ListView.builder(
            itemCount: storeicecreamList.length,
            itemBuilder: (context, index) {
              final storeicecrem = storeicecreamList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title:
                      Text('${storeicecrem.storeName} - ${storeicecrem.role}'),
                  subtitle: Text(
                      'Email: ${storeicecrem.email}\nPassword: ${storeicecrem.password}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        _showStoreForm(storeicecrem: storeicecrem);
                      } else if (value == 'Delete') {
                        _deleteStore(storeicecrem);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
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
