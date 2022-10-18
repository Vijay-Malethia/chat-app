import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class userImagePicker extends StatefulWidget {
  userImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  State<userImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<userImagePicker> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  void _pickUserImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = img;
    });
    widget.imagePickFn(File(img!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.teal[100],
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
        ),
        TextButton.icon(
            onPressed: _pickUserImage,
            icon: const Icon(Icons.image),
            label: const Text('Add image')),
      ],
    );
  }
}
