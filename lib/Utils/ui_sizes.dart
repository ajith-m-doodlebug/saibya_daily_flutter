import 'package:flutter/material.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 20.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 20.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);

const EdgeInsets screenSidePadding = EdgeInsets.symmetric(horizontal: 24);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

// 25
double headingFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.06;

// 20
double mediumFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.05;

// 17
double regularFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.04;

// 15
double smallFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.035;

// 12
double tinyFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.029;
