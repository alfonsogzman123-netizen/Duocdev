import 'package:flutter/material.dart';

class DuocCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const DuocCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.15)),
      ),
      child: child,
    );
  }
}
