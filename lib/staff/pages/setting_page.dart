import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final int initialCrossAxisCount;
  final Function(int) onCrossAxisCountChanged;

  const SettingsPage({
    super.key,
    required this.initialCrossAxisCount,
    required this.onCrossAxisCountChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _crossAxisCount;

  @override
  void initState() {
    super.initState();
    _loadCrossAxisCount();
  }

  // Load the saved crossAxisCount from SharedPreferences
  Future<void> _loadCrossAxisCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _crossAxisCount =
          prefs.getInt('crossAxisCount') ?? widget.initialCrossAxisCount;
    });
  }

  // Save the selected crossAxisCount to SharedPreferences
  Future<void> _saveCrossAxisCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('crossAxisCount', count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items per row:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildOption(2),
                const SizedBox(width: 20),
                _buildOption(3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int count) {
    return GestureDetector(
      onTap: () async {
        if (mounted) {
          setState(() {
            _crossAxisCount = count;
          });
          await _saveCrossAxisCount(count); // Save the selected value
          widget.onCrossAxisCountChanged(count); // Notify the parent
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _crossAxisCount == count ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            color: _crossAxisCount == count ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
