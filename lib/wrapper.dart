import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thejointapp/common_screens/sign_in.dart';
import 'package:thejointapp/common_screens/update_profile.dart';
import 'package:thejointapp/social/social_home.dart';
import 'models/user.dart';




class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool isUpdated = false;


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context); 
    
    if(user == null){
      return SignIn();
    }
    else{
      return StreamBuilder(
        stream: Firestore.instance.collection('userDetails').document(user.uid).snapshots(),
        builder: (context, snapshot){
          if(snapshot.data.exists){
            print(snapshot.data);
            return SocialHome();
          }
          else{
            return UpdateProfile();
          }
        },
      );
    }
  }


  // method to check if the user profile is already updated
  isUserProfileUpdated(uid){
     Firestore.instance
      .collection('userDetails')
      .document(uid)
      .get()
      .then((DocumentSnapshot ds){
        if(ds.exists){
          setState(() {
            isUpdated = true;
          });
        }
        else{
          setState(() {
            isUpdated = false;
          });
        }
      });
  }
}