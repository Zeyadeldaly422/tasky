import 'package:flutter/material.dart';

class Customcheckbox extends StatelessWidget {
  const Customcheckbox({super.key,required this.onChanged,required this.value});

final bool value;
final Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (bool? value) => onChanged(value),
      activeColor: Color(0xff15B86C),
    );
  }
}
