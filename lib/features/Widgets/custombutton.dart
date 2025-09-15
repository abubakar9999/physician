// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class customBuildButton extends StatelessWidget {
  final VoidCallback onClick;
  final IconData icon;
  final String title;
  final double sizeWidth;
  final Color inputColor;

    // ignore: use_key_in_widget_constructors
    customBuildButton({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
    required this.sizeWidth,
    required this.inputColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        // color: Color.fromARGB(255, 165, 162, 162),
        elevation: 5,
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: sizeWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: inputColor,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Icon(
                icon,
                color: title == 'New Order' ||
                        title == 'New DCR' ||
                        title == 'RX Capture'
                    ? const Color.fromARGB(255, 43, 114, 236)
                    : const Color.fromARGB(255, 27, 56, 34),
                size: 28,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 29, 67, 78),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
