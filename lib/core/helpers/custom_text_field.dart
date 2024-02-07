import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/input_formatters.dart';
import 'package:prosto_doc/core/helpers/textfield_theme.dart';

class CustomTextField extends StatefulWidget {
  final bool onError;
  final String hint;
  final bool isPhone;
  final bool isCode;
  final bool isDate;
  final bool isInn;
  final bool isName;
  final bool enabled;
  // bool expand;
  final Function()? onTap;
  final FocusNode? focusNode;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final double? padding;
  final ValueNotifier<bool>? listenable;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.isPhone,
    this.isInn = false,
    this.onTap,
    // this.expand = true,
    this.isName = false,
    this.enabled = true,
    this.focusNode,
    this.isDate = false,
    required this.textEditingController,
    this.isCode = false,
    this.onError = false,
    this.validator,
    this.padding,
    this.listenable,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // widget.focusNode?.addListener(
    //   () {
    //     setState(() {});
    //   },
    // );
    // print(widget.focusNode!.hasFocus);
    // widget.focusNode.

    return ValueListenableBuilder(
      valueListenable: widget.listenable ?? ValueNotifier(false),
      builder: (context, bool value, child) => GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 22),
          child: TextFormField(
            enabled: widget.enabled == false ? false : !widget.isDate,
            controller: widget.textEditingController,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.blackColor,
            ),
            // focusNode: widget.focusNode,
            cursorColor:
                widget.onError ? AppColors.errorColor : AppColors.textColor,
            // cursorHeight: 14.h,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color.fromRGBO(151, 151, 151, 1),
              ),
              isCollapsed: false,
              isDense: true,
              fillColor: Colors.white,
              filled: true,
              focusedErrorBorder: TextFieldTheme.errorBorder,
              errorBorder: TextFieldTheme.errorBorder,
              focusedBorder: TextFieldTheme.focusBorder,
              enabledBorder: TextFieldTheme.defaulBorder,
              disabledBorder: value
                  ? TextFieldTheme.focusBorder
                  : TextFieldTheme.defaulBorder,
              border: TextFieldTheme.defaulBorder,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
            keyboardType:
                widget.isCode || widget.isPhone ? TextInputType.phone : null,
            inputFormatters: [
              if (widget.isPhone) CustomInputFormatter(),
              if (widget.isName) NameInputFormatter(),
              if (widget.isCode && !widget.isInn)
                LengthLimitingTextInputFormatter(4),
              if (widget.isInn) LengthLimitingTextInputFormatter(12),
              if (widget.isInn) FilteringTextInputFormatter.digitsOnly,
            ],
            validator: widget.validator,
          ),
        ),
      ),
    );
  }
}
