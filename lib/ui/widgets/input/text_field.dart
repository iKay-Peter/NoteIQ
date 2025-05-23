import 'package:flutter/material.dart';
import 'package:notiq/app/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : widget.obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 14),
          cursorColor: Apptheme.orange,

          decoration: InputDecoration(
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: Colors.grey[500], size: 20)
                    : null,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                    : (widget.suffixIcon != null
                        ? Icon(
                          widget.suffixIcon,
                          color: Colors.grey[500],
                          size: 20,
                        )
                        : null),
            fillColor: Colors.grey[50],
            filled: true,
            hintText: widget.hintText ?? '',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
