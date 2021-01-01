import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Models
import 'models/postTemplateCondensed.dart';
import 'models/user.dart';

//PAGES
import 'createPost.dart';
import 'searchPage.dart';
import 'timeline.dart';
import 'viewProfile.dart';
import 'createNewUserPage.dart';







final Reference firebaseStorageRef = FirebaseStorage.instance.ref(); //To upload and storage the images

final postsRef = FirebaseFirestore.instance.collection('posts'); //To store information about the posts(title/description/tags/urls/ImageUrl)
final usersRef = FirebaseFirestore.instance.collection('users');//To store information about user profiles (id/username/email/displayPhoto/displayName/bio)
final commentsRef = FirebaseFirestore.instance.collection('comments');//To store comment information
final followersRef = FirebaseFirestore.instance.collection('followers');//To store comment information
final followingRef = FirebaseFirestore.instance.collection('following');//To store comment information

final GoogleSignIn googleSignIn = GoogleSignIn();
final DateTime timestamp = DateTime.now();

User currentUser; ///By creating a user variable containing all the data
///the user operating the app, we'll be able to pass that data throughout
///our app and provide access to more features to the user.

class loginPageOnlyGoogle extends StatefulWidget {
  @override
  _loginPageOnlyGoogleState createState() => _loginPageOnlyGoogleState();
}

class _loginPageOnlyGoogleState extends State<loginPageOnlyGoogle> {
  int pageIndex = 0;
  bool isAuth = false;
  PageController pageController;

  logout(){
    googleSignIn.signOut();
  }

  login(){
    googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //DETECTS WHEN A USER IS SIGNED IN
    googleSignIn.onCurrentUserChanged.listen((account) {
     handleSignIn(account);
    }, onError:(err) {
      print("ERROR : $err");
    } );
    // Re authenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account){
      handleSignIn(account);
    }, onError: (err){
      print("Error : $err");
    });
  }

  handleSignIn(GoogleSignInAccount account){
    if(account != null){
      print("User signed in: $account ");
      createUserInFirestore();
      setState(() {
        isAuth=true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }



  createUserInFirestore() async {
    /* 1) Check if user already exists in the firebase database
    according to their ID */
    final GoogleSignInAccount user = googleSignIn.currentUser;
    print("GoogleSingINAccountUSerId which will form the base for document in firebase ${user.id}");
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if(!doc.exists){
      /*2) If NOT, direct the user to the set up profile page. ->
     Get their username and generate new ID
     */
     final usernameAndLanguages = await Navigator.push(context, MaterialPageRoute(builder: (context) => createNewUserPage()));

     usersRef.doc(user.id).set({
       'id':user.id,
       'username':usernameAndLanguages['username'],
       'photoUrl':user.photoUrl,
       'email': user.email,
       'displayName': user.displayName,
       'bio':'',
       'languages':usernameAndLanguages['languages'],
       'timestamp': timestamp,
     });
     doc = await usersRef.doc(user.id).get();
    }

    setState(() {
      currentUser = User.fromDocument(doc);
    });
    // 3) Get username from the create accounts page and use it to create
    // a new user document in users collection.
  }

  Widget _buildLoginPage() {
    return Scaffold(
      body:Stack(
        children: [Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ThemeDark.png'),
                fit: BoxFit.fill,)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: login,
                child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/google_sign_up.png'),
                          fit: BoxFit.cover),
                    )
                ),

              ),
            ],
          ),
        ),
          Container(
              width: 260.0,
              height: 60.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logoBlackBG_preview_rev_1.png'),
                    fit: BoxFit.cover),
              )
          ),
        ],
      ),
    );
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  navigationOnTap(int index){
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget homeScreen(){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: <Widget>[
          viewProfile(profileID: currentUser?.id),
          Timeline(),
          createPost(currentUser : currentUser),
          search(),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color(0xFF0f0230),
        items: <Widget>[
          RadiantGradientMask(
            child: Icon(Icons.person,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.list,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.add,
                color: Colors.white,
                size: 35),
          ),
          RadiantGradientMask(
            child: Icon(Icons.search,
                color: Colors.white,
                size: 25),
          ),
          RadiantGradientMask(
            child: Icon(Icons.exit_to_app,
                color: Colors.white,
                size: 25),
          ),
        ],
        onTap: (index) {
          if(index == 4){
            logout();
          }
          //Handle button tap
          navigationOnTap(index);
        },
        height: 45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? homeScreen() : _buildLoginPage();
//    return Scaffold(
//      body:Stack(
//        children: [Container(
//          height: double.infinity,
//          width: double.infinity,
//          decoration: BoxDecoration(
//          image: DecorationImage(
//          image: AssetImage('assets/images/ThemeDark.png'),
//    fit: BoxFit.fill,)),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: [
//              GestureDetector(
//                onTap: login,
//                child: Container(
//                  width: 260.0,
//                  height: 60.0,
//                  decoration: BoxDecoration(
//                    image: DecorationImage(
//                      image: AssetImage('assets/images/google_sign_up.png'),
//                          fit: BoxFit.cover),
//                    )
//                  ),
//
//                ),
//            ],
//          ),
//          ),
//          Container(
//              width: 260.0,
//              height: 60.0,
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage('assets/images/logoBlackBG_preview_rev_1.png'),
//                    fit: BoxFit.cover),
//              )
//          ),
//      ],
//      ),
//    );
  }
}
