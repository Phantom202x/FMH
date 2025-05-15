import 'package:flutter/material.dart';
import 'package:app/views/app_views/main_view.dart';

class ResponsiveView extends StatefulWidget {
  const ResponsiveView({super.key});

  @override
  State<ResponsiveView> createState() => _ResponsiveViewState();
}

class _ResponsiveViewState extends State<ResponsiveView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MainAppView(); // MobileLayout();
        } else {
          return Placeholder();
        }
      },
    );
  }
}
