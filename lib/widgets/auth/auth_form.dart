import 'dart:developer';
import 'dart:io';
import 'package:chat_app/screens/forgot_pass_screen.dart';
import 'package:chat_app/services/authservices.dart';
import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLogin)
          SizedBox(
            height: 80,
          ),
        Center(
          child: Card(
            color: Colors.green[50],
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!_isLogin)
                        UserImagePicker(
                          imagePickFn: _pickedImage,
                        ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email address'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Username'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                        ),
                      if (!_isLogin)
                        TextFormField(
                          controller: _phonenumberController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          keyboardType: TextInputType.phone,
                        ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Password do not match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.validate;

                            AuthServices().submitAuthForm(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _usernameController.text.trim(),
                                _phonenumberController.text.trim(),
                                _userImageFile,
                                _isLogin,
                                context);
                          },
                          child: Text(_isLogin ? 'Login' : 'SignUp')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_isLogin)
                                Icon(
                                  Icons.arrow_back_outlined,
                                  size: 18,
                                ),
                              Text(_isLogin
                                  ? 'Create new account  '
                                  : " I already have an account"),
                              if (_isLogin)
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 18,
                                )
                            ],
                          )),
                      if (_isLogin)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ForgotPassScreen())),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                              )),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
