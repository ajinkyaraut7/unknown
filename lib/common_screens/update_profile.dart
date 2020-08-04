import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/services/auth.dart';
import 'package:thejointapp/services/databse.dart';
import 'package:thejointapp/social/social_home.dart';
import 'package:uuid/uuid.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  AuthService _auth = AuthService();
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name, number, gender, username, email = '', error = '', photoUrl;
  String fileName =
      "${DateTime.now().millisecondsSinceEpoch}image${Uuid().v1()}";
  bool loading = false;
  File _selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Let's get you started",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Log out'),
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    CircleAvatar(
                      // backgroundImage: _selectedImage == null
                      //     ? NetworkImage(user.photoUrl)
                      //     : Image.file(_selectedImage),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage)
                          : NetworkImage(user.photoUrl),
                      backgroundColor: Colors.grey,
                      radius: 60,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          getImageFile(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(user.email),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: new InputDecoration(
                    hintText: 'Full Name',
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      name = value.trim();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: numberController,
                  decoration: new InputDecoration(
                    hintText: 'Mobile Number',
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (val) {
                    if (val.length != 10) {
                      return "Enter valid number";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      number = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: new InputDecoration(
                    hintText: 'username',
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (val) {
                    if (val.length <= 3) {
                      return "username must be atleast 3 characters";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      username = usernameController.text.trim();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: gender,
                    hint: Text(
                      'Gender',
                    ),
                    onChanged: (val) => setState(() => gender = val),
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    items: ['Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                NiceButton(
                  width: 150,
                  elevation: 0,
                  radius: 20,
                  fontSize: 15,
                  background: Colors.black,
                  textColor: Colors.white,
                  text: 'Proceed',
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //store the image in storage
                      if (_selectedImage != null) {
                        StorageReference reference = FirebaseStorage.instance
                            .ref()
                            .child('social/photos/profilePics/${user.uid}/$fileName/');
                        StorageUploadTask uploadTask =
                            reference.putFile(_selectedImage);
                        // ignore: unused_local_variable
                        StorageTaskSnapshot taskSnapshot =
                            await uploadTask.onComplete;
                        var downloadURL = await (await uploadTask.onComplete)
                            .ref
                            .getDownloadURL();
                        photoUrl = downloadURL.toString();
                      } else {
                        photoUrl = user.photoUrl;
                      }
                      // store userDetails in database
                      dynamic result =
                          await DatabaseService(uid: user.uid).setUserData(
                        name: name,
                        number: number,
                        gender: gender,
                        profilePicUrl: photoUrl,
                        username: username,
                        email: user.email,
                      );
                      if (result != null) {
                        print(result);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SocialHome()));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //method to select the image and crop it for post
  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: source);

    //Cropping the image
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: image.path,
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: 'Cropper',
          statusBarColor: Colors.white,
          backgroundColor: Colors.black,
        ),
      );
      this.setState(() {
        _selectedImage = cropped;
      });
    }
  }
}
