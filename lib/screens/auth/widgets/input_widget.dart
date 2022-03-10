import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {required this.controller,
      required this.obscureText,
      required this.focusNode,
      required this.toggleObscureText,
      required this.validator,
      required this.prefIcon,
      required this.labelText,
      required this.textInputAction,
      required this.isEmailTextField,
      Key? key})
      : super(key: key);

  final bool isEmailTextField;

  final TextEditingController controller;
  final VoidCallback? toggleObscureText;
  final bool obscureText;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Icon prefIcon;
  final String labelText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        label: Text(labelText),
        prefixIcon: prefIcon,
        suffixIcon: IconButton(
          onPressed: toggleObscureText,
          icon: isEmailTextField
              ? const Icon(null)
              : obscureText
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
        ),
      ),
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      // onSaved: passwordVlidator,
    );
  }
}
