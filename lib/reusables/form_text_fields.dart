import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final List<FormFieldValidator<String>>? validators;
  final TextInputType keyboardType;

  const CustomFormTextField({
    super.key,
    required this.name,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validators,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
      ),
      validator:
          validators != null
              ? FormBuilderValidators.compose(validators!)
              : null,
    );
  }
}
