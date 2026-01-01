import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F4)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
