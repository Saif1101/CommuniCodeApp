
import 'package:flutter/material.dart';
import 'dart:async';


class createNewUserPage extends StatefulWidget {
  @override
  _createNewUserPageState createState() => _createNewUserPageState();
}

class _createNewUserPageState extends State<createNewUserPage> {
  final _formKey = GlobalKey <FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  String validationCheckString = "Enter Your Username";


  submitUsername(){
    final form = _formKey.currentState;

    if(form.validate()) { // go through all the validation steps once again
      form.save();
      final snackBar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), (){ /// Adding a 2 second delay before popping back to previous page
        Navigator.pop(context, username);
      }
      );
      ///pop navigator to go back to the previous route
    }//Returning the username to the previous page
  }

  Widget _validationDivider(){
    return Row(
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only( right: 10.0),
              child: Divider(
                color: Colors.white,
                height: 36,
              )
          ),
        ),
        Expanded(
          child:Center(
            child:
              Text(
              '$validationCheckString',
                style: TextStyle(
                  color: Colors.white,
                ),
        ),
          )
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only( left: 10.0),
              child: Divider(
                color: Colors.white,
                height: 36,
              )
          ),
        ),
      ]
    );
  }

  Widget _usernameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFFffffff),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: TextFormField(

                  validator: (value){
                    if(value.trim().length<3 || value.isEmpty){
                      setState(() {
                        validationCheckString = "Username too short";
                      });
                    } else if (value.trim().length>12) {
                      setState(() {
                        validationCheckString = "Username too short";
                      });
                    }
                  },
                  onSaved: (value)=> username = value,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Must be atleast 3 characters',
                    hintStyle: TextStyle(
                      color: Colors.black54
                    ),
                  ),
                ),
              ),
            )
        )
      ],
    );
  }

  Widget yellowUsernameIcon(){
    return SizedBox(
      height: 80.0,
      width: 290.0,
      child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(

            color: Color(0xFFf1b900),
            shape: BoxShape.rectangle,
            borderRadius:  new BorderRadius.all(Radius.circular(70.0)
            ),
          ),
          child: Text(
              'Pick a username',
              style: TextStyle(
                color: Colors.white,
                shadows: [
//                Shadow( // bottomLeft
//                    offset: Offset(-1.5, -1.5),
//                    color: Colors.grey
//                ),
//                Shadow( // bottomRight
//                    offset: Offset(1.5, -1.5),
//                    color: Colors.black
//                ),
//                Shadow( // topRight
//                    offset: Offset(1.5, 1.5),
//                    color: Colors.black
//                ),
//                Shadow( // topLeft
//                    offset: Offset(-1.5, 1.5),
//                    color: Colors.grey
//                ),
                ],

                letterSpacing: 1.6,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              )
          )
      ),
    );
  }


  Widget _loginButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical:1.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 25.0,
            onPressed: ()=> submitUsername(),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Color(0xFFf1b900),
            child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow( // bottomLeft
                        offset: Offset(-1.5, -1.5),
                        color: Colors.grey
                    ),
                    Shadow( // bottomRight
                        offset: Offset(1.5, -1.5),
                        color: Colors.black
                    ),
                    Shadow( // topRight
                        offset: Offset(1.5, 1.5),
                        color: Colors.black
                    ),
                    Shadow( // topLeft
                        offset: Offset(-1.5, 1.5),
                        color: Colors.grey
                    ),
                  ],

                  letterSpacing: 1.6,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                )
            )
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ThemeDark.png'),
              fit: BoxFit.fill,)
    ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFF).withOpacity(0.15)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              yellowUsernameIcon(),
              SizedBox(height: 10.0),
              _usernameField(),
              SizedBox(height: 10.0),
              _validationDivider(),
              SizedBox(height: 50.0),
              _loginButton(),
            ],

          ),
        ),
    )
    );
  }
}
