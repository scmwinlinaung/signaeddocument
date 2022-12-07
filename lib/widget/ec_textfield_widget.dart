// Flutter: Existing Libraries

// ECTextfieldWidget: StatelessWidget Class
import 'package:flutter/material.dart';

class ECTextfieldWidget extends StatelessWidget {
  // Final & Parameter: Class Properties
  final TextEditingController? controller;
  final String? title;
  final String? hint;
  final TextInputType textInputType;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool? isEditable;

  // Constructor
  const ECTextfieldWidget({
    required this.controller,
    required this.title,
    required this.hint,
    required this.textInputType,
    required this.maxLength,
    required this.maxLines,
    required this.validator,
    this.isEditable = true,
    Key? key,
  }) : super(key: key);

  // Build: Override Class Method
  @override
  Widget build(BuildContext context) {
    // Returning Widgets
    return TextFormField(
      readOnly: !isEditable!,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        labelText: title,
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.lightBlue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
