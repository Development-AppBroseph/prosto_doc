import 'dart:math';

import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]+'), '');
    final digitsOnlyChar = digitsOnly.split('');
    List<String> text = <String>[];
    for (var i = 0; i < digitsOnlyChar.length; i++) {
      if (i == 0) {
        if (digitsOnlyChar[0] == "7" || digitsOnlyChar[0] == "8") {
          text.add("+7 ");
        } else {
          text.add("+7 ");
          text.add(digitsOnlyChar[i]);
        }
      } else if (i == 4) {
        text.add(" ");
        text.add(digitsOnlyChar[i]);
      } else if (i == 7) {
        text.add(" ");
        text.add(digitsOnlyChar[i]);
      } else if (i == 9) {
        text.add("-");
        text.add(digitsOnlyChar[i]);
      } else if (i > 10) {
        break;
      } else {
        text.add(digitsOnlyChar[i]);
      }
    }

    final resultText = text.join('');

    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(
        offset: resultText.length,
      ),
    );
  }
}

class MMYYInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    if (newText.length > 5) {
      // Truncate the text if it exceeds the maximum length
      return TextEditingValue(
        text: newText.substring(0, 5),
        selection: newValue.selection.copyWith(
          baseOffset: min(newValue.selection.baseOffset, 5),
          extentOffset: min(newValue.selection.extentOffset, 5),
        ),
      );
    }

    if (newText.length == 3 && !newText.contains('/')) {
      // Add slash at the third position
      return TextEditingValue(
        text: '${newText.substring(0, 2)}/${newText.substring(2)}',
        selection: newValue.selection.copyWith(
          baseOffset: newValue.selection.baseOffset + 1,
          extentOffset: newValue.selection.extentOffset + 1,
        ),
      );
    }

    return newValue;
  }
}

class CVVTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    if (newText.length > 3) {
      // Truncate the text if it exceeds the maximum length
      return TextEditingValue(
        text: newText.substring(0, 3),
        selection: newValue.selection.copyWith(
          baseOffset: min(newValue.selection.baseOffset, 3),
          extentOffset: min(newValue.selection.extentOffset, 3),
        ),
      );
    }

    return newValue;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the input
    String cleanedValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Calculate the maximum allowed length with spaces
    int maxLengthWithSpaces = 16;

    // Ensure the cleaned value does not exceed the maximum length
    if (cleanedValue.length > maxLengthWithSpaces) {
      cleanedValue = cleanedValue.substring(0, maxLengthWithSpaces);
    }

    // Insert a space after every 4th digit
    String formattedValue = '';
    for (int i = 0; i < cleanedValue.length; i += 4) {
      formattedValue += cleanedValue.substring(i, i + 4) + ' ';
    }

    // Remove the trailing space if it exists
    formattedValue = formattedValue.trim();

    // Create the TextEditingValue with the formatted text
    TextEditingValue newTextValue = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );

    return newTextValue;
  }
}

class CardHolderInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Allow only letters (uppercase and lowercase) and spaces
    RegExp regex = RegExp(r'[a-zA-Z\s]*');
    final String formattedText =
        regex.allMatches(newText).map((match) => match.group(0)).join('');

    return TextEditingValue(
      text: formattedText.toUpperCase(),
      selection: newValue.selection.copyWith(
        baseOffset: formattedText.length,
        extentOffset: formattedText.length,
      ),
    );
  }
}

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Allow only letters (uppercase and lowercase) and spaces
    RegExp regex = RegExp(r'[a-zA-Zа-яА-Я\s]*');
    final String formattedText =
        regex.allMatches(newText).map((match) => match.group(0)).join('');

    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection.copyWith(
        baseOffset: formattedText.length,
        extentOffset: formattedText.length,
      ),
    );
  }
}
