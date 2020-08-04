import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thejointapp/social/social_others_profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  String search = "";


  @override
  void initState() {
    searchController.addListener(printLatestValue);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: new InputDecoration(
                focusColor: Colors.black,
                hoverColor: Colors.black,
                suffixIcon: Icon(Icons.search),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Search",
                  fillColor: Colors.white70),
            )),
            (search == null || search == "")?
          Padding(
            padding: const EdgeInsets.only(
              left:16,
              top: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Profiles you might recognise"),
              ],
            ),
          ):
          Container(),

          Expanded(
            child: StreamBuilder(
              stream: (search == null || search == "")
                  ? Firestore.instance.collection('userDetails').limit(20).snapshots()
                  : Firestore.instance
                      .collection("userDetails")
                      .where("searchIndex", arrayContains: search)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(snapshot.error),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map<Widget>((DocumentSnapshot document) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> OthersProfilePage(username: document['username'])));
                          },
                          child: ListTile(
                            title: (document['username'] != null)
                                ? Text(document['username'])
                                : Text("Name: ${document['name']}"),
                            subtitle: Text(document['name']),
                            leading: CircleAvatar(backgroundImage: NetworkImage('${document['profilePicUrl']}')),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
      ],
    );
  }

  printLatestValue(){
    setState(() {
      search = searchController.text.toLowerCase();
    });
    print(search);
  }
}
