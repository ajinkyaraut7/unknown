import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/common_screens/loading.dart';
import 'package:thejointapp/models/user.dart';
import 'package:thejointapp/services/databse.dart';
import 'package:thejointapp/social/social_home.dart';
import 'package:uuid/uuid.dart';

class PostContent extends StatefulWidget {
  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  final _formKey = GlobalKey<FormState>();
  String content = '';
  final TextEditingController myController = TextEditingController();
  int numLines = 0;
  File _selectedImage;
  bool imageProcessing = false;
  String fileName =
      "${DateTime.now().millisecondsSinceEpoch}image${Uuid().v1()}";
  bool posting = false;
  final String postId =
      '${DateTime.now().millisecondsSinceEpoch.toString()}${Uuid().v1()}';

  //Tags
  Iterable<String> listOfStringMatches;
  String hashtags = '';

  RegExp regExp = new RegExp(
    "#[a-z]{2,100}",
    caseSensitive: false,
    multiLine: false,
  );
  RegExp textExp = new RegExp(
    "[a-z0-9]",
    caseSensitive: false,
    multiLine: false,
  );
  ///Tags



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return posting
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Post Content',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: imageProcessing
                ? Loading()
                : SingleChildScrollView(
                    child: StreamBuilder<UserData>(
                        stream: DatabaseService(uid: user.uid).userData,
                        builder: (context, snapshot) {
                          UserData userData = snapshot.data;
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: _selectedImage != null
                                      ? Image.file(_selectedImage)
                                      : Container(),
                                  color: Colors.red,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: myController,
                                        maxLines: 10,
                                        validator: (value) => value.isEmpty
                                            ? 'Please write your post'
                                            : null,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Write your post here'),
                                        onChanged: (val) {
                                          setState(() {
                                            content = val;
                                            print(val);
                                            numLines =
                                                ' '.allMatches(val).length + 1;
                                          });
                                        },
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
                                      background: Colors.grey[900],
                                      text: 'Upload Image',
                                      onPressed: () {
                                        getImageFile(ImageSource.gallery);
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    NiceButton(
                                      width: 150,
                                      elevation: 0,
                                      radius: 20,
                                      fontSize: 15,
                                      background: Colors.grey[900],
                                      text: 'Post',
                                      onPressed: () async {
                                        //tags
                                        if ((myController.text)
                                                .toString()
                                                .length >
                                            2) {
                                          hashtags = '';

                                          Iterable<Match> matches = regExp
                                              .allMatches(myController.text);

                                          List<Match> listOfMatches =
                                              matches.toList();
                                          listOfStringMatches =
                                              listOfMatches.map((Match m) {
                                            return m.input
                                                .substring(m.start, m.end);
                                          });

                                          for (var i
                                              in listOfStringMatches.toList()) {
                                            DatabaseService(uid: user.uid)
                                                .addHashtags(i);
                                          }
                                          print('posted successfully');
                                        } else {
                                          print('unsucessfull posting');
                                        }
                                        //tags
                                        uploadContent(
                                            content,
                                            userData,
                                            numLines,
                                            user,
                                            listOfStringMatches.toList());
                                        myController.clear();
                                        
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
          );
  }

  // method to upload the content and store it in social feedCollection and the userCollection
  uploadContent(content, userData, numLines, user, hashtags) async {
    var postUrl;
    setState(() {
      posting = true;
    });
    if(_selectedImage !=null){
      StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('social/posts/${user.uid}/$fileName/');
    StorageUploadTask uploadTask = reference.putFile(_selectedImage);
    // ignore: unused_local_variable
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var downloadURL = await (await uploadTask.onComplete).ref.getDownloadURL();
     postUrl = downloadURL.toString();
    }else{
      postUrl = null;
    }
    print('download url: $postUrl');
    await DatabaseService(uid: user.uid).uploadOnFeedCollection(
      content: content,
      profilePicUrl: userData.profilePicUrl,
      hashtags: hashtags,
      numLines: numLines,
      username: userData.username,
      imageUrl: postUrl,
      postId: postId,
      retweeted: false,
      retweetPostId: null,
    );

    await DatabaseService(uid: user.uid).uploadOnUserPostCollection(
      content: content,
      profilePicUrl: userData.profilePicUrl,
      hashtags: hashtags,
      numLines: numLines,
      username: userData.username,
      imageUrl: postUrl,
      postId: postId,
      retweeted: false,
      retweetPostId: null,
    );

    setState(() {
      posting = false;
    });
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SocialHome()));
    
  }


  //method to select the image and crop it for post
  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: source);

    //Cropping the image
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
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
