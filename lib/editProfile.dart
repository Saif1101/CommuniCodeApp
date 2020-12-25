import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_inventory/googleLoginScreen.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class editProfile extends StatefulWidget {
  final String currentUserID;

  editProfile({this.currentUserID});

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _bioValid = true;
  bool _userNameValid = true;


  TextEditingController usernameController = TextEditingController();
  TextEditingController userBioController = TextEditingController();

  bool isLoading = false;
  User user;

  @override
  void initState() {
    // TODO: implement initState

    getUser();
    super.initState();
  }

  Widget linearProgress(){
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
    );
  }

  getUser() async{
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserID).get();
    user = User.fromDocument(doc);
    usernameController.text = user.username;
    userBioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildUsernameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(top:12.0,bottom: 7.5),
          child: Text("Username",
          style: TextStyle(
            color: Colors.black
          ),)
        ),
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
              )
            ]
          ),
          child: TextField(
            controller:usernameController,
            decoration: InputDecoration(
              focusColor: Colors.amberAccent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0)
            ),
          ),
        )
      ],
    );
  }

  Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:  EdgeInsets.only(top:12.0,bottom: 5.0),
            child: Text("Bio",
              style: TextStyle(
                  color: Colors.black
              ),)
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                )
              ]
          ),
          child: TextField(
            controller:userBioController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0)
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userBioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  updateProfileData(){
    setState(() {
      usernameController.text.trim().length<3||
      usernameController.text.isEmpty? _userNameValid = false : _userNameValid = true;

      userBioController.text.trim().length>80||
          userBioController.text.isEmpty? _bioValid = false : _bioValid = true;
    });
    if(_userNameValid && _bioValid){
      usersRef.doc(widget.currentUserID).update({
        'username': usernameController.text.trim(),
        'bio': userBioController.text.trim(),
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 1), () {
       Navigator.pop(context);
      });
    }
    else if(usernameController.text.trim().length<3){
      SnackBar snackbar = SnackBar(content: Text("Username too short"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    else if(userBioController.text.trim().length>80){
      SnackBar snackbar = SnackBar(content: Text("Bio should be less than 80 words"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body: isLoading?linearProgress(): ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:16.0, bottom:8.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildUsernameField(),
                      SizedBox(height: 10.0,),
                      buildBioField(),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: updateProfileData,
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),)
                    ],
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
