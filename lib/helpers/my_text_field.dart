import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText1;
  final String? hintText2;
  final TextInputType? keyboardType;

  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText1,
    this.hintText2,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText1 != null ? hintText1 : 'Error: กรุณากรอก URL', // แสดงข้อความ Error ถ้าไม่ได้กรอกข้อมูลลง textfile แรก
        
        contentPadding: const EdgeInsets.only(
          left: 16.0,
          bottom: 12.0,
          top: 12.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(0.5),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
    );
  }
}
