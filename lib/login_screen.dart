import 'package:coding_inventory/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            child: TextField(
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
  }
  Widget _loginButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical:25.0),
        width: double.infinity,
        child: RaisedButton(
            elevation: 25.0,
            onPressed: ()=> print("Login Button Pressed"),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Color(0xFFf1b900),
            child: Text(
                "ENTER THE LOOP",
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
  Widget _passwordTF(){
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
            child: TextField(
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
}
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
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
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
                        Container(
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
                              "LOGIN",
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
                        ),
                      ),
                        //
                        SizedBox(height: 50.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            _emailTF(),
                            SizedBox(
                              height: 5.0,
                            ),
                            _passwordTF(),
                            _forgotPassword(),
                            _loginButton(),

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
