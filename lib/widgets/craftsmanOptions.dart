import 'package:flutter/material.dart';

class CraftsmanOptions extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final String value;
  final String selectedOption;
  final VoidCallback onTap;

  const CraftsmanOptions({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.value,
    required this.selectedOption,
    required this.onTap, required bool isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005A9C) : const Color(0xFFE6F0FA),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
