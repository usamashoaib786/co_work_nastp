import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppFormField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? fontsize;
  final dynamic fontweight;
  final bool containerBorderCondition;
  final String texthint;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? bgcolor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextInputType? txtType;
  const CustomAppFormField({
    super.key,
    this.containerBorderCondition = false,
    required this.texthint,
    required this.controller,
    this.validator,
    this.height,
    this.width,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.cursorHeight,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.fontweight,
    this.fontsize,
    this.hintStyle,
    this.errorText,
    this.cursorColor,
    this.bgcolor,
    this.txtType,
  });

  @override
  State<CustomAppFormField> createState() => _CustomAppFormFieldState();
}

class _CustomAppFormFieldState extends State<CustomAppFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.appColor),
          color: widget.bgcolor ?? Color(0xffF1F4FF),
          borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: widget.controller,
        cursorColor: AppTheme.appColor,
        onChanged: widget.onChanged,
        keyboardType: widget.txtType ?? TextInputType.name,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.texthint,
            hintStyle: const TextStyle(
                color: Color(0xff626262),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            isDense: true),
      ),
    );
  }
}

class CustomAppPasswordfield extends StatefulWidget {
  final double? height;
  final double? width;
  final bool containerBorderCondition;
  final String texthint;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;

  const CustomAppPasswordfield({
    super.key,
    this.containerBorderCondition = false,
    required this.texthint,
    required this.controller,
    this.validator,
    this.height,
    this.width,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.cursorHeight,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.errorText,
    this.cursorColor,
  });

  @override
  State<CustomAppPasswordfield> createState() => _CustomAppPasswordfieldState();
}

class _CustomAppPasswordfieldState extends State<CustomAppPasswordfield> {
  bool _obscureText = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.appColor),
            color: Color(0xffF1F4FF),
            borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: widget.controller,
          cursorColor: AppTheme.appColor,
          obscureText: _obscureText,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 50,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintText: widget.texthint,
              hintStyle: const TextStyle(
                  color: Color(0xff626262),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              isDense: true,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.appColor,
                  ),
                ),
              )),
        ));
  }
}

class FloatingLabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const FloatingLabelTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppTheme.appColor.withValues(alpha: 0.5), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    );
  }
}
