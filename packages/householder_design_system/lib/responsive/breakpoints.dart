import 'package:flutter/widgets.dart';

enum WindowSize { compact, medium, expanded }

class Breakpoints {
  const Breakpoints._();

  static const double mediumMin = 600;
  static const double expandedMin = 900;

  static WindowSize of(double width) {
    if (width >= expandedMin) return WindowSize.expanded;
    if (width >= mediumMin) return WindowSize.medium;
    return WindowSize.compact;
  }

  static bool isCompact(BuildContext context) =>
      of(MediaQuery.sizeOf(context).width) == WindowSize.compact;
}
