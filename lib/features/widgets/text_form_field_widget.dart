import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {Key? key, this.controller, this.keyboardType, this.maxLength, this.onChanged, this.validator, this.label, this.hintText, this.readOnly = false, this.onTap, this.prefixIcon})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  final int? maxLength;

  final void Function(String text)? onChanged;
  final String? Function(String? text)? validator;
  final Widget? label;
  final String? hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 16,
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        disabledBorder:const OutlineInputBorder(borderRadius: BorderRadius.zero),
        label: label,
        hintText: hintText,
        counterText: '',
      ),
    );
  }
}
