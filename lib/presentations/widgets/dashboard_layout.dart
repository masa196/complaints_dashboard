import 'package:flutter/material.dart';
import 'page_header.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final Widget? action;

  const DashboardLayout({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            PageHeader(
              title: title,
              subtitle: subtitle,
              action: action,
            ),
            const SizedBox(height: 24),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
