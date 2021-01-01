
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'postTemplateExpanded.dart';




class postTemplate extends StatelessWidget {
  final String title;
  final String description;
  final List <String> tags ;
  final List<String> urlList;
  final String postImageUrl;
  final String postID;
  final String ownerID;

  factory postTemplate.fromDocument(DocumentSnapshot doc) {
  return postTemplate(
    ownerID: doc.data()["ownerID"],
    postID: doc.data()['postID'],
  title: doc.data()['postTitle'],
  description: doc.data()['description'],
  postImageUrl: doc.data()['imageUrl'],
  urlList: doc.data()['siteLinks'].cast<String>(),
  tags:  doc.data()['tags'].cast<String>(),
  );
  }

  postTemplate({this.ownerID, this.title, this.description, this.tags, this.urlList,
  this.postImageUrl,this.postID});



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
        width: 350,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: ListTile(
                  title: Text(title),
                  trailing: GestureDetector(
                    onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> postExpanded(ownerID: ownerID, title: title, description: description, tags: tags, urlList: urlList, postImageUrl: postImageUrl,postID: postID,))),
                    child: RadiantGradientMask(child: Icon(Icons.arrow_forward,size: 35,color: Colors.white,),),
                  ),
                ), //Title and Read More Button that directs to an instance of postTemplateExpanded
              ),
              Divider(thickness: 1.5,),
              Expanded(child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.vertical(top:Radius.circular(34),bottom:Radius.circular(34),),
                ),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(22)),
                      child: Image(image: CachedNetworkImageProvider(postImageUrl),
                        fit: BoxFit.contain,
                        height: 300,),),),) //Post image displayed in a rounded rectanglle
            ],
          ),
        ),
      ),
    );
  }




}
//blue-purple gradient-> applied on the follow/edit button and the buttons of the curved navigation bar at the bottom

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.centerLeft,
        colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}