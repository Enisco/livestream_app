// /*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.height,
    this.width,
    this.leftPadding,
    this.labelText,
    this.textEditingController,
    this.onSuffixIconPressed,
    this.suffix,
    this.suffixIcon,
    this.focusNode,
    this.initialValue,
    this.onPrefixIconPressed,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.prefix,
    this.prefixIcon,
    this.readOnly,
    this.prefixStyle,
    this.floatingLabelStyle,
    this.hintStyle,
    this.suffixIconSize,
    this.obscureText,
    this.showCursor,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.onTap,
    this.mainFillColor,
    this.iconBgFillColor,
    this.cursorColor,
    this.borderColor,
    this.textAlign,
    this.textAlignVertical,
    this.inputStringStyle,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization,
    this.contentpadding,
    this.scrollPadding,
    this.onSubmitted,
    this.autofocus,
    this.enabled = true,
    this.filled,
    this.suffixText,
    this.isCollapsed,
    this.floatingLabelBehavior,
    this.hintText,
  }) : super(key: key);

  final double? height, width, leftPadding;
  final EdgeInsets? scrollPadding;
  final String? labelText;
  final String? prefixText;
  final String? initialValue;
  final double? suffixIconSize;
  final String? suffixText;
  final String? hintText;
  final bool? enabled;
  final bool? filled;
  final bool? readOnly;
  final bool? autofocus;
  final bool? isCollapsed;
  final bool? showCursor;
  final int? maxLines;
  final int? maxLength;
  final bool? obscureText;
  final Widget? suffix, prefix, prefixIcon;
  final IconData? suffixIcon;
  final FocusNode? focusNode;
  final Color? mainFillColor;
  final Color? borderColor;
  final Color? iconBgFillColor;
  final Color? cursorColor;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? inputStringStyle;
  final TextStyle? hintStyle;
  final TextStyle? prefixStyle;
  final TextStyle? floatingLabelStyle;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final void Function()? onSuffixIconPressed;
  final void Function()? onPrefixIconPressed;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentpadding;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: height ?? 56,
        width: width ?? size.width,
        padding: EdgeInsets.only(left: leftPadding ?? 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white54,
          border: Border.all(
            color: borderColor ?? Colors.lightGreen,
          ),
        ),
        child: Center(
          child: TextFormField(
            enabled: enabled,
            autofocus: autofocus ?? false,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            obscuringCharacter: '*',
            initialValue: initialValue,
            focusNode: focusNode,
            controller: textEditingController,
            showCursor: showCursor ?? true,
            autocorrect: false,
            textAlign: textAlign ?? TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters ?? [],
            textInputAction: textInputAction,
            onChanged: onChanged,
            onTap: () =>
                onTap ?? FocusScope.of(context).requestFocus(focusNode),
            onFieldSubmitted: ((value) {
              onSubmitted ??
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
            }),
            decoration: InputDecoration(
              isCollapsed: isCollapsed ?? false,
              floatingLabelBehavior: floatingLabelBehavior,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen, width: 0.0),
              ),
              counterText: "",
              suffix: suffix,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              prefix: prefix,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              prefixStyle: prefixStyle,
              suffixText: suffixText,
              labelText: labelText,
              hintText: hintText ?? '',
              labelStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              hintStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              filled: filled ?? false,
              fillColor: Colors.transparent,
              focusColor: Colors.amber,
              floatingLabelStyle: floatingLabelStyle,
            ),
          ),
        ),
      ),
    );
  }
}

// */