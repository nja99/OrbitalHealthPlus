import 'package:flutter/material.dart';

class UserTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const UserTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.validator,
    this.onTap
    });

  @override
  State<UserTextField> createState() => _UserTextFieldState();
}

class _UserTextFieldState extends State<UserTextField> {

  late bool _isObscured;

  @override void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: _isObscured,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
              width: 1.5
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
              width: 1.5
            ),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 8),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
            fontSize: 16,
          ),
          suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        ),
      ),
    );
  }
}
