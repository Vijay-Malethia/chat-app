import 'dart:io';

import 'package:chat/widgets/picker/image_user_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isloading);
  final bool isloading;
  final void Function(
    String email,
    String username,
    String password,
    bool islogin,
    BuildContext ctx,
    File imgage,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImge;

  void _pickedImage(File image) {
    _userImge = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_userImge == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid == true) {
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
        _userImge!,
      );
      _formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color.fromARGB(255, 218, 253, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10),
        elevation: 4,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) userImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _userEmail = value.toString();
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email address'),
                      ),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _userName = value.toString();
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 4) {
                            return 'Username must be at least four characters';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text('Username')),
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      onSaved: (value) {
                        _userPassword = value.toString();
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 7) {
                          return 'Password must be at least seven characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'SignUp')),
                    const SizedBox(
                      height: 8,
                    ),
                    if (!widget.isloading)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'create new account'
                              : 'I have already an account')),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
