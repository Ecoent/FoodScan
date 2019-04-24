import 'package:flutter/material.dart';

class CustomPadding extends Padding {

  CustomPadding(Widget child, padding):
        super(
        child: child,
        padding : padding,
      );
}

class CustomText extends Text {

  CustomText(String data, {color: Colors.black, textAlign: TextAlign.center, factor: 1.0}):
        super(data,
        textAlign: textAlign,
        textScaleFactor: factor,
        style: new TextStyle(color: color),
      );
}