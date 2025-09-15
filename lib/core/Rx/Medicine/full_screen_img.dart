import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:photo_view/photo_view.dart';

class FullPageImg extends StatefulWidget {
  const FullPageImg({Key? key}) : super(key: key);

  @override
  State<FullPageImg> createState() => _FullPageImgState();
}

class _FullPageImgState extends State<FullPageImg> {
  String? imgpath;
  ImageSource imgsorce = ImageSource.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: imgpath == null
                  ? const SizedBox(
                      height: 200,
                      width: 200,
                      child: Icon(
                        Icons.people,
                        size: 40,
                      ))
                  : FullScreenWidget(
                      child: PhotoView(
                        imageProvider: FileImage(File(
                          imgpath!,
                        )),
                      ),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    _pickimg();
                    imgsorce = ImageSource.camera;
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    imgsorce = ImageSource.gallery;
                    _pickimg();
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallary")),
            ],
          )
        ],
      ),
    );
  }

  void _pickimg() async {
    final pickimg = await ImagePicker()
        .pickImage(source: imgsorce, preferredCameraDevice: CameraDevice.front);
    if (pickimg != null) {
      setState(() {
        imgpath = pickimg.path;
      });
    }
  }
}
