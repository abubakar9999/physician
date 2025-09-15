// ignore_for_file: file_names, must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class NewOrderCustomerListCardWidget extends StatelessWidget {
  String clientName;
  String base;
  String marketName;
  String outstanding;
  NewOrderCustomerListCardWidget({
    Key? key,
    required this.clientName,
    required this.base,
    required this.marketName,
    required this.outstanding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                clientName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 30, 66, 77),
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          base + ' ' + '' + marketName,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 30, 66, 77),
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
