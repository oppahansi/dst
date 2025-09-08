// Package Imports
import "package:flutter/material.dart";

double screenWidth(BuildContext context, double percent) =>
    MediaQuery.of(context).size.width * percent;

double screenHeight(BuildContext context, double percent) =>
    MediaQuery.of(context).size.height * percent;

double gapSize(BuildContext context) => screenWidth(context, 0.05);
double gapSizeSmall(BuildContext context) => screenWidth(context, 0.02);
double gapSizeLarge(BuildContext context) => screenWidth(context, 0.1);
