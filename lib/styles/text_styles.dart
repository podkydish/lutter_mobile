import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle defaultTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle boldTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: Color(0xFF515357),
  );

  static const TextStyle rearTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Color(0xFF515357),
  );

  static const TextStyle underTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Color(0xFF93959A),
  );

  static const TextStyle additionalText = TextStyle(
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    fontSize: 16,
    color: Color(0xFF515357),
  );

  static const TextStyle linkText = TextStyle(
    height: 1.5,
    decoration: TextDecoration.underline,
    color: Colors.blue,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    fontSize: 14,
  );
}
