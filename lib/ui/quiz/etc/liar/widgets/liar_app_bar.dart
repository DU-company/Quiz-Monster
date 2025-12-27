import 'package:flutter/material.dart';

class LiarAppBar extends StatelessWidget {
  final String label;
  final VoidCallback onBackPressed;
  const LiarAppBar({
    super.key,
    required this.label,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(label),
      leading: IconButton(
        onPressed: onBackPressed,
        icon: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
