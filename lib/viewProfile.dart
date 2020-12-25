import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

//Pages
import 'editProfile.dart';
import 'googleLoginScreen.dart';
import 'models/user.dart';
import 'models/postTemplateCondensed.dart';


class viewProfile extends StatefulWidget {
  final String profileID;

  viewProfile({this.profileID});
  @override
  _viewProfileState createState() => _viewProfileState();
}

class _viewProfileState extends State<viewProfile> {
  final String currentUserId = googleSignIn.currentUser.id;
  bool postsLoading = false;
  List<Widget>postTemplateTry=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePosts();
  }

  getProfilePosts  () async {
    print("Getting profile posts");
    setState(() {
      postsLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
    .doc(currentUserId)
    .collection('userPosts')
    .orderBy('timestamp',descending: true)
    .get();
    print("Query get complete");
    setState(() {
      print("Making posts from document");
      postTemplateTry = snapshot.docs.map<Widget>((doc) => postTemplate.fromDocument(doc)).toList();
      print("Post making complete");
      postsLoading = false;

    });
  } //Querying firestore and yielding all posts by the user whose profile is being visited

  buildPosts(){
    if(postsLoading){
      return Container(
        padding: EdgeInsets.only(bottom: 10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple),
        ),
      );
    } else if(!postsLoading && postTemplateTry.length != 0 ){
      return SizedBox(height: 300,
          width: MediaQuery.of(context).size.width,
          child: Swiper(layout: SwiperLayout.STACK, itemCount: postTemplateTry.length,itemHeight: 300,itemWidth: 350, itemBuilder: (context, index){return postTemplateTry[index];},));

    }
    else if(!postsLoading && postTemplateTry.length==0){
      return Center(
        child: (
        Text("No Posts!")
        ),
      );
    }
  } //Returning a SWIPER Widget containing all posts moulded in the format specified by the postTemplateCondensed

  buildCountsRow(int followerCount, int followingCount) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 38.0, left: 38.0, top: 15, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(followerCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,),
              ),
              Text('followers',
                style: TextStyle(
                  color: Colors.white,
                ),)
            ],
          ),
          Container(
            color: Colors.white,
            width: 0.2,
            height: 22,
          ),
          Column(
            children: [
              Text(followingCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,),
              ),
              Text('following',
                style: TextStyle(
                  color: Colors.white,
                ),)
            ],
          ),
          Container(
            color: Colors.white,
            width: 0.2,
            height: 22,
          ),
          buildProfileButton(),
        ],
      ),
    );
  } //Returns row containing the number of followers/following/posts
  //^^^TO BE REPLACED BY BADGES

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.purple),
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.done) {
          User user = User.fromDocument(snapshot.data);

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, top: 7),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: CachedNetworkImageProvider(
                          user.photoUrl),
                      //Add backgroundImage: User's Profile Image
                    ),
                  ), //CircleAvatar for Profile Photo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Text('${user.username}',
                          style: GoogleFonts.fjallaOne(
                            fontSize: 40,
                            color: Colors.white
                           )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text('${user.displayName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ) // Column Containing Username and DisplayName

                ],
              ),
              //Follwer/Following Counts, Follow Button
              buildCountsRow(32, 12),
              //User Bio Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                child: Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                  ),
                ),
              ),
            ],);
        }
        else {
          return Text("Something Went Wrong!");
        }
      },
    );
  }

  buildButton({String text, Function function}){
  return Container(
    padding: EdgeInsets.only(left:18, right:  18, top: 8, bottom:8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(33)),
        gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
            begin: Alignment.bottomRight,
            end: Alignment.centerLeft)
    ),
    child: GestureDetector(
      onTap: function,
      child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
  } // button to display given text and perform specified function

  pushToEditProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> editProfile(currentUserID: widget.profileID)));
  } //Method to specify whether to direct FOLLOW/EDIT button press to edit profile page

  buildProfileButton(){
    // viewing your own profile - should show edit profile button
    //viewing someone else's profile -> should show follow button
    bool isProfileOwner;
    isProfileOwner= currentUserId == widget.profileID;
    if(isProfileOwner){
      return buildButton(
          text: "Edit Profile",
      function: pushToEditProfile);
    }
    return(Text("buttonValue is null"));
  } //building the EDIT/FOLLOW Button next to the followers/following counts



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff09031D),
        body: Stack(
          children: [
            Positioned.fill(
                child: Image(
                  image: AssetImage('assets/images/ThemeDark.png'),
                  fit : BoxFit.fill,
    )),
            ListView(
//        mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SizedBox(height: 30,),
                buildProfileHeader(),
                SizedBox(height: 30,),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                        color:  Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.vertical(top:Radius.circular(34),bottom:Radius.circular(34) )
                    ),
                    child: Column(
                      children: [
                        Align(alignment: Alignment(-0.9,-0.9),
                            child: Text("Posts",
                              style: TextStyle(color: Color(0xFF414C6B),
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                        buildPosts()
                      ],
                    ),
                  ),
                )
              ],
    ),
          ],
        )
    );
  }
}
