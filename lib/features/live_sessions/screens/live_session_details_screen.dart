import 'package:flutter/material.dart';

/// Live session details screen placeholder — will be replaced with full implementation.
class LiveSessionDetailsScreen extends StatelessWidget {
  final String sessionId;
  const LiveSessionDetailsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('تفاصيل الحصة: $sessionId')),
    );
  }
}
