import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:thejointapp/models/user.dart';


class DatabaseService{
  final String uid;


  DatabaseService({this.uid});
  

  final CollectionReference userCollection =
      Firestore.instance.collection('userDetails');


  // method to set user data from the update profile page
  Future setUserData({name, number, profilePicUrl, username, gender, email})async{

    //method to split name and username and store it in array for searching purpose
    List<String> splitListName = name.split(" ");
    List<String> indexListName = [];

    for (int i = 0; i < splitListName.length; i++) {
      for (int y = 1; y < splitListName[i].length + 1; y++) {
        indexListName.add(splitListName[i].substring(0, y).toLowerCase());
      }
    }

    List<String> splitListName1 = name.split("(****)");
    List<String> indexListName1 = [];

    for (int i = 0; i < splitListName1.length; i++) {
      for (int y = 1; y < splitListName1[i].length + 1; y++) {
        indexListName1.add(splitListName1[i].substring(0, y).toLowerCase());
      }
    }

    List<String> splitListUsername = username.split(" ");
    List<String> indexListUsername = [];

    for (int i = 0; i < splitListUsername.length; i++) {
      for (int y = 1; y < splitListUsername[i].length + 1; y++) {
        indexListUsername
            .add(splitListUsername[i].substring(0, y).toLowerCase());
      }
    }
    indexListName1.addAll(indexListUsername);

    indexListName.addAll(indexListName1);

    return await userCollection.document(uid).setData({
      'name': name,
      'number': number,
      'profilePicUrl': profilePicUrl,
      'username': username,
      'gender': gender,
      'email': email,
      'searchIndex': indexListName,
    });
  }


  // method for getting current user details
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      gender: snapshot.data['gender'],
      number: snapshot.data['number'],
      email: snapshot.data['email'],
      username: snapshot.data['username'],
      profilePicUrl: snapshot.data['profilePicUrl'],
      
    );
  }


  // setting up stream to get user current details
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }


  // method to upload post in the social->feedCollection
  

  Future uploadOnFeedCollection({content, numLines, hashtags, profilePicUrl,username, imageUrl, postId, retweeted, retweetPostId})async{
    CollectionReference feedPost = Firestore.instance.collection('social')
      .document('posts').collection('feedCollection');

    return await feedPost.document(postId).setData({
      'content':content,
      'uploadTime': DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()),
      'numLines': numLines,
      'hashtags': hashtags,
      'profilePicUrl': profilePicUrl,
      'username': username,
      'postId': postId,
      'imageUrl':imageUrl,
      'retweeted': retweeted,
      'retweetPostId': retweetPostId,
      'uid':uid,
    });
  }


  //method to upload post in socila->userPost collecetion
  Future uploadOnUserPostCollection({content, numLines, hashtags, profilePicUrl,username, imageUrl, postId, retweeted, retweetPostId})async{
    CollectionReference userPost = Firestore.instance.collection('social')
      .document('posts').collection('userPostCollection').document(uid).collection('userPosts');

    return await userPost.document(postId).setData({
      'content':content,
      'uploadTime': DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()),
      'numLines': numLines,
      'hashtags': hashtags,
      'profilePicUrl': profilePicUrl,
      'username': username,
      'postId': postId,
      'imageUrl': imageUrl,
      'retweeted': retweeted,
      'retweetPostId': retweetPostId,
      'uid':uid,
    });
  }


  //adding hashtags in social->hashtags
  final CollectionReference hashtags =
      Firestore.instance.collection('social').document('trends').collection('hashtags');
  final CollectionReference posts = Firestore.instance.collection('Posts');
  Future addHashtags(i) async {
    hashtags.document(i).get().then((value) async {
      if (value.exists) {
        int vol;
        await hashtags.document(i).get().then((value) {
          vol = (value.data['timeStamps'].length);
          hashtags.document(i).setData({
            'hashtag': i,
            'volume': vol + 1,
            'mostrecent': DateTime.now(),
            'timeStamps': FieldValue.arrayUnion([DateTime.now()])
          }, merge: true);
        });
      } else {
        hashtags.document(i).setData({
          'hashtag': i,
          'volume': 1,
          'trendScore': -1,
          'mostrecent': DateTime.now(),
          'timeStamps': FieldValue.arrayUnion([DateTime.now()])
        }, merge: true);
      }
    });
  }
}