import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('pass').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot post = snapshot.data.documents[index];
              return Card(
                color: Colors.pink[50],
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(post['oUsername'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                      subtitle: Text(post['oContent'].toString(), 
                      style: TextStyle(
                        fontSize: 12
                      ),),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('${post['oProfilePicUrl']}'),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text(post['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          subtitle: Text(post['content'].toString(), 
                          style: TextStyle(
                            fontSize: 18
                          ),),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage('${post['profilePicUrl']}'),
                          ),
                        ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text('Loading...'),
          );
        }
      },
    );
  }
}
