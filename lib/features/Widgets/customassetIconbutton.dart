// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class customBuildIconButton extends StatelessWidget {
  final VoidCallback onClick;
  final String icon;
  final String title;
  final double sizeWidth;
  final Color inputColor;
  double height;
  double width;

  customBuildIconButton({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
    required this.sizeWidth,
    required this.inputColor,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        elevation: 5,
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: sizeWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: inputColor,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Expanded(
                child: Image.asset(
                  icon,
                  height: height,
                  width: width,
                  fit: BoxFit.contain,
                )

            ),
            //const SizedBox(width: 5,),
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
