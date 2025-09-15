import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../person_wise_activity.dart';
import '../structure_wise_activity.dart';


class ActivityLog extends StatelessWidget {
  const ActivityLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Log"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(height: 20,),
            //
            // Card(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   elevation: 1,
            //   child: Container(
            //     decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(12)),
            //     height: 60,
            //     width: 260,
            //     child: TextButton.icon(
            //       onPressed: () async {
            //         await Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => StructureWiseActivity(),
            //         ));
            //
            //       },
            //       label: const FittedBox(
            //         child: Text(
            //           'Structure wise Activity',
            //           style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
            //         ),
            //       ),
            //       icon: const Icon(
            //         Icons.local_activity,
            //         color: Colors.white,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
        
            const SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(12)),
                height: 60,
                width: 260,
                child: TextButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PersonWiseActivity(),
                    ));
                  },
                  label: const FittedBox(
                    child: Text(
                      'Person wise Activity',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

        
          ],
        ),
      ),
    );
  }
}
