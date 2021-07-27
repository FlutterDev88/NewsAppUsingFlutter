import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTap;
  final bool isTextObscured;
  final bool isReadOnly;
  final bool isAutoCompleteEnabled;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Color textColor;

  const RoundedInputField(
      {Key key,
      this.icon,
      this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.onTap,
      this.width,
      this.backgroundColor,
      this.borderColor,
      this.isTextObscured = false,
      this.keyboardType = TextInputType.text,
      this.textEditingController,
      this.isReadOnly = false,
      this.focusNode,
      this.isAutoCompleteEnabled = true,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    var color = backgroundColor ?? theme.scaffoldBackgroundColor;
    var border = borderColor ?? kThemeData.dividerColor;
    if (isReadOnly) {
      color = color.withAlpha(140);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: kSmallPadding),
      padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
      width: width != null ? width : kCalculatedWidth(size),
      decoration: kTextFieldBoxDecoration.copyWith(
          color: color, border: Border.all(color: border)),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        obscureText: isTextObscured,
        cursorColor: kPrimaryColor,
        focusNode: focusNode,
        readOnly: isReadOnly,
        autocorrect: isAutoCompleteEnabled,
        decoration: InputDecoration(
            icon: this.icon == null ? null : Icon(icon, color: kPrimaryColor),
            hintText: hintText,
            hintStyle: textColor == null
                ? theme.textTheme.bodyText1
                : theme.textTheme.bodyText1.copyWith(color: textColor),
            border: InputBorder.none),
        style: textColor == null
            ? theme.textTheme.bodyText1
            : theme.textTheme.bodyText1.copyWith(color: textColor),
        controller: textEditingController,
      ),
    );
  }
}