import 'package:flutter/material.dart';
import 'package:student_app/responsive/responsive_builder.dart';

import '../enums/device_screen_type.dart';


class ScreenTypeLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const ScreenTypeLayout({
    required key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          if (tablet != null) {
            return tablet;
          }
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Desktop) {
          if (desktop != null) {
            return desktop;
          }
        }

        return mobile;
      },
    );
  }
}
