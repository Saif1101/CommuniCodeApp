import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;



class commentModel extends StatefulWidget {
  @override


  _commentsPageState parent;

  final String username;
  final String userID;
  final String avatarURL;
  final String comment;
  final Timestamp timestamp;
  bool hasCookie =false;


  commentModel({this.parent,this.username, this.userID, this.avatarURL, this.comment,
      this.timestamp, this.hasCookie});
  _commentModelState createState() => _commentModelState(hasCookie: hasCookie, username: username, avatarURL: avatarURL,
      userID: userID, comment: comment,timestamp: timestamp);

  factory commentModel.fromDocument(DocumentSnapshot doc,{parent}){
    return commentModel(
      parent: parent,
      username: doc.data()['username'],
      userID: doc.data()['userID'],
      comment: doc.data()['comment'],
      timestamp: doc.data()['timestamp'],
      avatarURL: doc.data()['avatarURL'],
      hasCookie: doc.data()['hasCookie'],
    );
  }
}

class _commentModelState extends State<commentModel> {
  _commentsPageState parent;
  final String username;
  final String userID;
  final String avatarURL;
  final String comment;
  final Timestamp timestamp;
  bool hasCookie=false;
  int buttonpressCounter = 0;


 _commentModelState({Key key,this.hasCookie, this.username, this.userID, this.avatarURL, this.comment, this.timestamp});

 awardCookie() async {

   if(currentUser.id == widget.parent.ownerID && currentUser.id!=userID) {

     buttonpressCounter += 1;

     if (buttonpressCounter <= 5) {
       if (widget.parent.cookiesLeft == 0) {
         setState(() {});
       }
       else {
         if (hasCookie) {
           widget.parent.cookiesLeft += 1;
           await usersRef.doc(userID).update({'cookies':FieldValue.increment(-1)});
           activityFeedRef.doc(userID).collection('feedItems').add({
             "type": "cookie",
             "timestamp": timestamp,
             "postId": widget.parent.postID,
             "userId": currentUser.id,
             "username": currentUser.username,
             "userProfileImg": currentUser.photoUrl,
             "mediaUrl": widget.parent.postImageURL,
           });
         } else {
           widget.parent.cookiesLeft -= 1;
           await usersRef.doc(userID).update({'cookies':FieldValue.increment(1)});
         }


         await commentsRef.doc(widget.parent.postID).collection('comments')
             .where('timestamp', isEqualTo: timestamp)
             .where('comment', isEqualTo: comment)
             .where('userID', isEqualTo: userID)
             .get()
             .then((querySnapshot) {
           querySnapshot.docs.forEach((documentSnapshot) {
             documentSnapshot.reference.update({'hasCookie': !hasCookie});
           });
         });


         hasCookie = !hasCookie;
         setState(() {});
       }
     } else {

       Timer(Duration(seconds: 10), () => buttonpressCounter = 0);
     }
   }
 }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap:()=> awardCookie(),
      child: Card(
          elevation: 10.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarURL),
            ),
            title: Text(comment),
            subtitle: Row(
              children: [
                Text("$username"),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(timeago.format(timestamp.toDate())),
                )
              ],
            ),
            trailing: hasCookie?CircleAvatar(
              backgroundImage: AssetImage('assets/images/cookieVector.jpg')):Text(''),
          )
      ),
    );
  }
}

class commentsPage extends StatefulWidget {
  final String ownerID;
  final String postID;
  final String postImageURL;
  int cookiesLeft;

  commentsPage({Key key,this.cookiesLeft, this.postID, this.postImageURL, this.ownerID}) : super(key: key);

  @override
  _commentsPageState createState() => _commentsPageState(cookiesLeft: cookiesLeft,postID: this.postID, postImageURL: this.postImageURL, ownerID: this.ownerID);

}

class _commentsPageState extends State<commentsPage> {
  TextEditingController commentController = TextEditingController();
  int cookiesLeft;
  final String ownerID;
  final String postID;
  final String postImageURL;

  _commentsPageState({this.cookiesLeft,this.postID, this.postImageURL, this.ownerID});

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCookiesLeft();
  }

  getCookiesLeft(){

  }


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
                comments.add(commentModel.fromDocument(doc,parent: this));
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
      'hasCookie':false
    });
    bool isNotPostOwner = ownerID != currentUser.id; //Only add a notification if someone else is commenting on the post
    // and not the original owner himself
    if (isNotPostOwner) {
      activityFeedRef.doc(ownerID).collection('feedItems').add({
        "type": "comment",
        "commentData": commentController.text,
        "timestamp": timestamp,
        "postId": postID,
        "userId": currentUser.id,
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "mediaUrl": postImageURL,
      });
    }
    commentController.clear();
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


