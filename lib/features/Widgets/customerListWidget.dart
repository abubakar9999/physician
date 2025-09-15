// ignore_for_file: file_names, must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class CustomerListCardWidget extends StatelessWidget {
  String clientName;
  String clientId;
  String docDegree;
  String address;
  CustomerListCardWidget({
    Key? key,
    required this.clientName,
    required this.docDegree,
    required this.address,
  required this.clientId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 70),
      child: Container(
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
                  "$clientName | $clientId",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 30, 66, 77),
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // base + ' ' + ',' + '' + marketName,//todo Old
                       // docCat.isEmpty?'': docCat+ ', ' + docType+ ' ' + '' + address,
                        (docDegree.isEmpty ? '' : docDegree) + (address.toString().isEmpty ? '' : ', ' + address.toString()),
                       //  docDegree.isEmpty?'': docDegree + address.toString().isEmpty?'': ', ' + address,
                        maxLines: 3,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 30, 66, 77),
                            fontSize: 16),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
