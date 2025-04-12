import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  final Future<void> Function()? onPressed; // Accept an async callback
  final bool isEnabled;

  const PaymentButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled
          ? () async {
              if (onPressed != null) {
                await onPressed!(); // Await the async callback
              }
            }
          : null, // Disable the button if isEnabled is false
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Colors.green : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Proceed to Payment',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
