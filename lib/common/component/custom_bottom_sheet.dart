import 'package:flutter/material.dart';
import 'package:quiz/common/data/colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String desc;
  final String label;
  final String redLabel;
  final VoidCallback onRedPressed;
  final VoidCallback onPressed;
  final double? height;
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.desc,
    required this.label,
    required this.redLabel,
    required this.onRedPressed,
    required this.onPressed,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(title: title),
              _Description(desc: desc),
              _Buttons(
                label: label,
                redLabel: redLabel,
                onRedPressed: onRedPressed,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        // color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String desc;
  const _Description({
    super.key,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: desc.isEmpty ? null : Colors.black12,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: SingleChildScrollView(
          child: Text(
            desc,
            style: TextStyle(
              // color: Colors.white,
              fontSize: 18,
              height: 1.2,
              wordSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final String label;
  final String redLabel;
  final VoidCallback onRedPressed;
  final VoidCallback onPressed;
  const _Buttons({
    super.key,
    required this.label,
    required this.redLabel,
    required this.onRedPressed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(foregroundColor: MAIN_COLOR),
            onPressed: onRedPressed,
            child: Text(
              redLabel,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
