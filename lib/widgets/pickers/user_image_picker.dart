import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({
    super.key,
    required this.imagePickFn,
    this.currentImage,
  });

  final void Function(File pickedImage) imagePickFn;
  String? currentImage = '';

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 200);
    setState(() {
      _pickedImage = pickedImageFile == null ? null : File(pickedImageFile.path);
    });
    if (pickedImageFile != null) {
    widget.imagePickFn(File(pickedImageFile.path));
  }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.currentImage == null && _pickedImage == null)
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey,
          ),
        if (widget.currentImage != null || _pickedImage != null)
          CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!) as ImageProvider
                  : CachedNetworkImageProvider(widget.currentImage!)),
        if (widget.currentImage != null || _pickedImage != null)
          TextButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text(
              'Change Image',
            ),
          ),
        if (widget.currentImage == null && _pickedImage == null)
          TextButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text(
              'Add Image',
            ),
          ),
      ],
    );
  }
}
