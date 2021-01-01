

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../comments.dart';


class postExpanded extends StatefulWidget {
  final String ownerID;
  final String title;
  final String description;
  final List <String> tags ;
  final List<String> urlList;
  final String postImageUrl;
  final String postID;


  @override
  _postExpandedState createState() => _postExpandedState(ownerID: ownerID, title: title, description: description, tags: tags, urlList: urlList, postImageUrl: postImageUrl, postID: postID);

  postExpanded({this.ownerID, this.title, this.description, this.tags, this.urlList,
      this.postImageUrl,this.postID});


}

class _postExpandedState extends State<postExpanded> {
 List <Widget> _buttons = [];

 final String ownerID;
 final String postID;
 final String title;
 final String description;
 final List<String> tags;
 final List<String> urlList;
 final String postImageUrl;

 _postExpandedState({this.ownerID, this.title,this.description,this.tags,this.urlList,this.postImageUrl,this.postID});

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    buildLinkButtonRow();
  }




  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } //Method to facilitate launching of links

  buildTagsRow(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(32.0),
      child: Container(
        height: 44,
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(22))
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(width:2, color: Colors.black)
              ),
              margin: EdgeInsets.only(right: 13, left: 13),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, right: 15, left:15
                ),
                child: Text(tags[index],
                  style: TextStyle(
                      color: Colors.black
                  ),),
              ),
            );
          },
        ),
      ),
    );
  } //Horizontal ListView to view all tags related to the post

  ovalClipIconButton(String siteName, String url){
    return Container(
      width: 56,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 1.0,
            )
          ]
      ),
      child: ClipOval(
        child: Material(// button color
          child: InkWell(
            splashColor: Colors.red, // inkwell color
            child: SizedBox(width: 56, height: 56, child:Image(
              image: new AssetImage("assets/Icons/$siteName.png"),
              width: 32,
              height:32,
              color: null,
              fit: BoxFit.scaleDown,
            ),),
            onTap: () => _launchURL(url),
          ),
        ),
      ),
    );
  } //Oval buttons that display the passed image and open the corresponding link on button press

   buildLinkButtonRow () {
    List<Widget> buttons= new List();
    for(int i = 0; i<urlList.length; i+=2){
        Widget b1 =  ovalClipIconButton(urlList[i], urlList[i+1]);
        buttons.add(b1);
    }
    setState((){
      _buttons = buttons;
    });
  } // Method that processes the urls to yield OvalButtons that direct user to links

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(  //
              child: Image(
                image: AssetImage('assets/images/grayBG.png'),
                fit : BoxFit.fill,
              )),
          SafeArea(
            bottom: false,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.only(bottomRight:Radius.circular(34),)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 310,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(

                                title: Text(
                                  title,
                                  softWrap: true,
                                  style: TextStyle(
                                  fontFamily:'Avenir',
                                  fontSize: 31,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,),
                                  textAlign: TextAlign.left,
                                ),
                                trailing: IconButton(icon: Icon(Icons.message), onPressed: ()=>showComments(
                                  context,
                                  postImageURL : postImageUrl,
                                  postID: postID)
                                )),
                              ),
                            Divider(color: Colors.black38),
                            Center(
                              child: buildTagsRow(),
                            ),
                            Divider(color: Colors.black38),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:  5),
                              child: Text(description,
                                softWrap: true,

                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _buttons,
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>expandPhoto(imageUrl: postImageUrl,title: title,))),
                      child: Hero(tag:'image',
                        child: Align(
                          alignment: Alignment(0,-1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(22)),
                                child: Image(image: CachedNetworkImageProvider(postImageUrl),fit: BoxFit.contain,height:300)),
                        ),
                      )
                  ), //postImage
                ],
              ),
          ),
        ],
      ),
    );
  }
}


//Class that displays the expanded view of the photo, allows zoom/etc. using the photo view library.
class expandPhoto extends StatelessWidget {
  final String title;
  final String imageUrl;
  expandPhoto({this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      backgroundColor: Colors.grey,
      body: Container(
        child: Center(
          child: Hero(
            tag: 'image',
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),

        ),
      ),
    );
  }
}

showComments(BuildContext context, {String postID, String postImageURL, String ownerID}){
  Navigator. push(context, MaterialPageRoute(builder: (context){
    return commentsPage(
      ownerID: ownerID,
      postID: postID,
      postImageURL: postImageURL,
    );
  }
  )
  );
}


