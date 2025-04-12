import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/admin/admin_model/manage_menu.dart';

class IceCreamCart extends StatefulWidget {
  const IceCreamCart({super.key});

  @override
  State<IceCreamCart> createState() => _IceCreamCartState();
}

class _IceCreamCartState extends State<IceCreamCart> {
  Future<List<MenuItem>> fetchMenuItems() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('menuItems').get();
    return querySnapshot.docs
        .map((doc) => MenuItem.fromFirestore(doc))
        .toList();
  }

  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menuItems');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _menuCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No menu items found.'));
          }

          final menuItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final data = menuItems[index];
              // final id = data.id;
              final title = data['title'];
              final price = data['price'];
              //final categories = data['categories'];
              final imagePath = data['image'];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: File(imagePath).existsSync()
                      ? Image.file(
                          File(imagePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image),
                  title: Text(title),
                  subtitle: Text("Price: \$${price.toStringAsFixed(2)}"),
                ),
              );
            },
          );
        });
  }
}
