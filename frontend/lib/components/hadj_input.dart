import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HadjInput extends StatefulWidget {
  final String hinttext;
  final TextEditingController controller;
  final Icon icon;
  final bool isPassword;
  final Function()? onTap;
  final TextInputType? keyboardType; // Added keyboard type
  final String? Function(String?)? validator; // Added custom validator
  final List<TextInputFormatter>? inputFormatters; // Added input filtering
  final TextInputAction? textInputAction; // Added text input action
  final int? maxLength; // Added max length
  final int? maxLines; // Added max lines
  final bool? enabled; // Added enabled state
  final TextCapitalization textCapitalization; // Added text capitalization

  const HadjInput({
    super.key,
    required this.hinttext,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.onTap,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<HadjInput> createState() => _HadjInputState();
}

class _HadjInputState extends State<HadjInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF39CC20).withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          focusNode: _focusNode,
          onTap: widget.onTap,
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          textCapitalization: widget.textCapitalization,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: _obscureText
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                  )
                : widget.icon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xFF39CC20),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hinttext,
            hintStyle: GoogleFonts.poppins(),
            errorStyle: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
