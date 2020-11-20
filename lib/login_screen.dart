import 'package:coding_inventory/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType {
  login,
  registration
}
class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _formValidationString="Enter Details";
  FormType _formType = FormType.login;

  //METHODS
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()){
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
    }
  }

  void moveToRegister(){
    setState(() {
      _formType = FormType.registration;
    });
  }


  //DESIGN
  Widget _loginValidatorBox(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.0,top: 5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Color(0xFFf1b900),
        borderRadius: BorderRadius.circular(30.0),

      ),
      child:
        Center(
          child:
            Text(
              '$_formValidationString',
            style: TextStyle(
              color: Colors.white,
//              shadows: [
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
//              ],

              letterSpacing: 1.6,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            )
        )


    );
  } //To Display The Status (Valid/Invalid login Details)
  Widget _emailTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFFf1b900),
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
            child: TextFormField(
              validator: (value){
                if(value.isEmpty){
                  setState(() {
                    _formValidationString ='Invalid Email/Password ';
                  });
                }
                return null;
              },
              onSaved: (value)=>_email = value,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:14.0),
                prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                ),
                hintText: 'Enter your User-ID',
                hintStyle: kHintTextStyle,
              ),
            )
        )
      ],
    );
  } //Email Text Field
  Widget _loginButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical:1.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 25.0,
            onPressed: ()=> validateAndSubmit(),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Color(0xFFf1b900),
            child: Text(
                _formType == FormType.login ? 'ENTER THE LOOP':'REGISTER',
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
  }//Login Button
  Widget _passwordTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFFf1b900),
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
            child: TextFormField(
              validator: (value){
                if(value.isEmpty){
                  setState(() {
                    _formValidationString ='Invalid Email/Password ';
                  });
                }
                return null;
              },
              onSaved: (value)=> _password = value,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:14.0),
                prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
            )
        )
      ],
    );
}//Password Text Field
  Widget _forgotPassword(){
    return Container(
      alignment: Alignment.centerRight,

      child: FlatButton(
          onPressed: ()=>print("Forget Password Button Pressed"),
          padding: EdgeInsets.only(top: 5.0,right: 0.0),
          child: Text(
              "Forgot Password?",
              style: kLabelStyle
          )
      ),
    );
}//Forgot Password Button
  Widget _topLoginIcon(){
    return Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(

          color: Color(0xFFf1b900),
          shape: BoxShape.rectangle,
          borderRadius:  new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0),
          ),
        ),
        child: Text(
            _formType == FormType.login ? 'LOGIN':'REGISTER',
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
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )
        )
    );
}//textbox displaying 'LOGIN'
  Widget _registerButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical:10.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 25.0,
            onPressed: ()=> moveToRegister(),
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Color(0xFFf1b900),
            child: Text(
                "Register",
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
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                )
            )
        )
    );
  }

  //Page Design

  //////////////////////////////////////////////REGISTRATION PAGE WIDGET////////////////////////////////////////////////////////
  Widget _pages(){
    if(_formType == FormType.login){
      return Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          _emailTF(),
          SizedBox(
            height: 7.0,
          ),
          _loginValidatorBox(),
          SizedBox(
            height: 5.0,
          ),
          _passwordTF(),
          _forgotPassword(),
          _loginButton(),
          _registerButton(),
        ],
      );
    }
    else {
      return Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          _emailTF(),
          SizedBox(
            height: 7.0,
          ),
          _loginValidatorBox(),
          SizedBox(
            height: 5.0,
          ),
          _passwordTF(),
          _registerButton(),
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,

        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginBGPlain.png'),
                fit: BoxFit.fill,
              )
          ),
        child: Stack(
          children:<Widget> [
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 150,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child:
                        _topLoginIcon(),
                      ),
                        //
                        SizedBox(height: 50.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Form(
                              key: formKey ,
                              child: _pages(),
                            ),
                          ],

                        )
                      ],
                    ),


              )),

              ])
            )
      ),
        );
}
}
