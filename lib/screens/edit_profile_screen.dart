import 'dart:developer';
import 'dart:io';

import 'package:chat_app/screens/forgot_pass_screen.dart';
import 'package:chat_app/services/authservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/pickers/user_image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final currentuser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  File? _userImageFile;
  var isLoading = false;

  String? email = '';
  bool editprofile = true;
  TextEditingController _currentpass = TextEditingController();
  TextEditingController _newpass = TextEditingController();

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  var initValues = {
    'image_url': '',
    'phone_number': '',
    'username': '',
  };

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser!.uid)
        .get();

    setState(() {
      initValues['username'] = userSnap.data()!['username'];
      initValues['image_url'] = userSnap.data()!['image_url'];
      initValues['phone_number'] = userSnap.data()!['phone_numer'];
      email = userSnap.data()!['email'];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(editprofile ? "Edit Profile" : 'Change Password')),
        backgroundColor: Colors.teal[50],
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Card(
                  color: Colors.green[50],
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (editprofile)
                              UserImagePicker(
                                imagePickFn: _pickedImage,
                                currentImage: initValues['image_url'],
                              ),
                            if (editprofile)
                              TextFormField(
                                initialValue: initValues['username'],
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Username'),
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (newValue) =>
                                    initValues['username'] = newValue,
                              ),
                            if (editprofile)
                              TextFormField(
                                initialValue: initValues['phone_number'],
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Phone Number'),
                                keyboardType: TextInputType.phone,
                                onChanged: (newValue) =>
                                    initValues['phone_number'] = newValue,
                              ),
                            if (!editprofile)
                              TextFormField(
                                controller: _currentpass,
                                decoration: InputDecoration(
                                    labelText: 'Current Password'),
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Password must be at least 7 characters long';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                            if (!editprofile)
                              TextFormField(
                                controller: _newpass,
                                decoration:
                                    InputDecoration(labelText: 'New Password'),
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Password must be at least 7 characters long';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                            SizedBox(
                              height: 15,
                            ),
                            if (editprofile)
                              ElevatedButton(
                                  onPressed: () async {
                                    _formKey.currentState!.validate;

                                    AuthServices().submitChangeForm(
                                        _userImageFile,
                                        currentuser,
                                        initValues,
                                        context);
                                  },
                                  child: Text('Save Changes')),
                            if (!editprofile)
                              ElevatedButton(
                                  onPressed: () async {
                                    _formKey.currentState!.validate;

                                    AuthServices().changepass(
                                        email!,
                                        _currentpass.text.toString(),
                                        _newpass.text.toString(),
                                        context,
                                        currentuser!);
                                  },
                                  child: Text('Change Password')),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    editprofile = !editprofile;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (!editprofile)
                                      Icon(
                                        Icons.arrow_back_outlined,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                    Text(
                                      editprofile
                                          ? 'Change Password  '
                                          : " Edit Profile",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 11),
                                    ),
                                    if (editprofile)
                                      Icon(
                                        Icons.arrow_forward_outlined,
                                        size: 18,
                                        color: Colors.black,
                                      )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
