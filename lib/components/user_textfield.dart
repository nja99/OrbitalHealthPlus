import 'package:flutter/material.dart';

class UserTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const UserTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText
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
      padding: const EdgeInsetsDirectional.fromSTEB(35, 12, 35, 0),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2
            ),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 8),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
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
