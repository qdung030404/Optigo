import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Using a placeholder emoji or image for the UK flag
          const Text('🇬🇧', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            'English',
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
