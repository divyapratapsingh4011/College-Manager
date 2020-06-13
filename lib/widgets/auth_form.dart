import 'dart:io';

import 'package:college_manager/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/enums.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    BuildContext ctx, {
    String name,
    String email,
    String password,
    bool isLogin,
    String stream,
    String phn,
    String reg,
    User userType,
    File image,
  }) _submit;
  final bool isLoading;
  AuthForm(this._submit, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool didChange = true;
  String _name;
  File _storedImage;
  bool _isLogin;
  User _userType;
  String _stream;
  String _email;
  String _reg;
  String _phn;

  final psww = TextEditingController();

  setUser(User selection) {
    setState(() {
      _userType = selection;
    });
  }

  setStream(String stream) {
    if (stream == 'CSE')
      setState(() {
        _stream = "CSE";
      });
    if (stream == 'ECE')
      setState(() {
        _stream = "ECE";
      });
    if (stream == 'IT')
      setState(() {
        _stream = "IT";
      });
    if (stream == 'Ist_year')
      setState(() {
        _stream = "Ist_year";
      });
  }

  void _selectImage() async {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.camera, imageQuality: 50);
                        if (File(_picked.path) == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.camera),
                      label: Text('Camera'),
                    ),
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (_picked == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Gallery'),
                    ),
                  ],
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _stream == null && _userType == User.student) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      // print(_userType.toString());
      widget._submit(
        context,
        name: _name,
        email: _email,
        password: psww.text,
        isLogin: _isLogin,
        stream: _stream,
        phn: _phn,
        reg: _reg,
        userType: _userType,
        image: _storedImage,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _isLogin = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (didChange) {
      SharedPreferences.getInstance().then((value) {
        if (value.getString('lastuser') == 'User.admin')
          setState(() {
            _userType = User.admin;
          });
        if (value.getString('lastuser') == 'User.teacher')
          setState(() {
            _userType = User.teacher;
          });
        if (value.getString('lastuser') == 'User.student')
          setState(() {
            _userType = User.student;
          });
        didChange = !didChange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          elevation: 20,
          color: Theme.of(context).accentColor,
          child: Card(
            elevation: 40,
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (!_isLogin) UserImageInput(_selectImage, _storedImage),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (_isLogin)
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Radio(
                                      value: User.admin,
                                      groupValue: _userType,
                                      onChanged: (value) => setUser(value),
                                    ),
                                    Text('Admin'),
                                  ],
                                ),
                              ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Radio(
                                    value: User.teacher,
                                    groupValue: _userType,
                                    onChanged: (value) => setUser(value),
                                  ),
                                  Text('Teacher'),
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Radio(
                                    value: User.student,
                                    groupValue: _userType,
                                    onChanged: (value) => setUser(value),
                                  ),
                                  Text('Student'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Enter Your name"),
                          key: ValueKey('name'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) return 'Enter a name';
                            return null;
                          },
                          onSaved: (newValue) => _name = newValue.trim(),
                        ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Enter your email'),
                        key: ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!value.contains('@') || !value.contains('.com'))
                            return 'Please enter a valid email.';
                          return null;
                        },
                        onSaved: (newValue) {
                          _email = newValue.trim();
                        },
                      ),
                      if (_userType == User.student && !_isLogin)
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Enter your Registration No.'),
                            key: ValueKey('reg'),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: (value) {
                              if (value.length != 8)
                                return 'Please enter a valid registration no.';
                              return null;
                            },
                            onSaved: (newValue) {
                              _reg = newValue.trim();
                            }),
                      if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Enter your Phone Number'),
                          key: ValueKey('phn'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.length != 10)
                              return 'Please Enter a valid Phone Number';
                            return null;
                          },
                          maxLength: 10,
                          onSaved: (newValue) => _phn = newValue.trim(),
                        ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Enter your Password'),
                        key: ValueKey('psw'),
                        obscureText: true,
                        controller: psww,
                        validator: (value) {
                          if (value.length < 6)
                            return 'Password should be of atleast 6 characters';
                          return null;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          key: ValueKey('cpsw'),
                          obscureText: true,
                          validator: (value) {
                            if (value.trim() != psww.text.trim())
                              return 'Password doesn\'t match';
                            return null;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (_userType == User.student && !_isLogin)
                            Row(children: <Widget>[
                              DropdownButton(
                                icon: Icon(Icons.expand_more),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('CSE'),
                                    value: 'CSE',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('ECE'),
                                    value: 'ECE',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('IT'),
                                    value: 'IT',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Ist Year'),
                                    value: 'Ist_year',
                                  ),
                                ],
                                onChanged: (value) => setStream(value),
                                value: _stream,
                              ),
                            ]),
                          if (widget.isLoading) CircularProgressIndicator(),
                          if (!widget.isLoading)
                            RaisedButton.icon(
                              onPressed: _trySubmit,
                              icon: _isLogin
                                  ? Icon(Icons.beenhere)
                                  : Icon(Icons.border_color),
                              label: _isLogin ? Text('Login') : Text('Sign Up'),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (!widget.isLoading)
                        FlatButton(
                          onPressed: _userType == User.admin
                              ? null
                              : () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                          child: _isLogin
                              ? Text('I don\'t have an account')
                              : Text('Already have an account'),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
