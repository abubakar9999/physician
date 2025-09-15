// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  const PrimaryButton({Key? key, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width / 1.5,
      // width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: const Color(0xff70BA85)),
      child: Text(
        buttonText,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
