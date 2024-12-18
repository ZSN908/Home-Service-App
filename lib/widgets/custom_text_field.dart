import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTextField({
  bool authForm = true,
  required TextEditingController controller,
  required String hintText,
  bool obscureText = false,
  IconData? icon,
  Function? onIconPressed,
  bool multiLines = false,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: authForm ? 8.0 : 4),
    decoration: BoxDecoration(
      color: authForm ? Colors.grey.withOpacity(0.1) : Colors.white,
      borderRadius: BorderRadius.circular(authForm ? 30 : 12),
      border: authForm ? null : Border.all(color: Colors.black, width: 1),
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: authForm ? 17 : 12.7, vertical: authForm ? 0 : 5),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              maxLines: multiLines ? 5 : 1,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
                border:
                    InputBorder.none, // Always none; handled by the container
              ),
            ),
          ),
        ),
        if (icon != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: IconButton(
              onPressed: () => onIconPressed?.call(),
              icon: Icon(
                icon,
                size: 23,
              ),
            ),
          ),
      ],
    ),
  );
}
