import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class commentModel extends StatelessWidget {
  final String username;
  final String userID;
  final String avatarURL;
  final String comment;
  final Timestamp timestamp;

  const commentModel({Key key, this.username, this.userID, this.avatarURL, this.comment, this.timestamp}) : super(key: key);

  factory commentModel.fromDocument(DocumentSnapshot doc){
    return commentModel(
      username: doc.data()['username'],
      userID: doc.data()['userID'],
      comment: doc.data()['comment'],
      timestamp: doc.data()['timestamp'],
      avatarURL: doc.data()['avatarURL'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarURL),
          ),
          title: Text(comment),
          subtitle: Row(
            children: [
              Text("sfkn11"),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(timeago.format(timestamp.toDate())),
              )
            ],
          ),
        )
    );
  }
}

class commentsPage extends StatefulWidget {
  final String ownerID;
  final String postID;
  final String postImageURL;

  const commentsPage({Key key, this.postID, this.postImageURL, this.ownerID}) : super(key: key);

  @override
  _commentsPageState createState() => _commentsPageState(postID: this.postID, postImageURL: this.postImageURL, ownerID: this.ownerID);

}

class _commentsPageState extends State<commentsPage> {
  TextEditingController commentController = TextEditingController();
  final String ownerID;
  final String postID;
  final String postImageURL;

  _commentsPageState({this.postID, this.postImageURL, this.ownerID});

  buildComments(){
    return StreamBuilder(
      stream: commentsRef.doc(postID).collection('comments')
          .orderBy('timestamp',descending: false).snapshots(),
        builder: (context,snapshot){
            if (!snapshot.hasData) {
              return (Text("No Comments Yet!"));
            }
            else{
              List<commentModel> comments = [];
              snapshot.data.documents.forEach((doc){
                comments.add(commentModel.fromDocument(doc));
              });
              return ListView(children: comments,);
            }
        }
        );
  }

  addComment(){
    commentsRef
        .doc(postID)
        .collection("comments")
        .add({
      "username":currentUser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarURL": currentUser.photoUrl,
      "userID": currentUser.id,
    });
    commentController.clear();
  }
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
          elevation: 10.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildComments()
          ),
          Divider() ,
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment...",
              ),
            ),
            trailing: OutlineButton(
              onPressed: ()=> addComment(),
              borderSide: BorderSide.none,
                child: Text("Post"),
            ),
          )
        ],
      ),
    );
  }
}


