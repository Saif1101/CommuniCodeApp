import 'package:flutter/material.dart';

class linkButtons extends StatefulWidget {
  final List<String> urlList = ['Website1','http://google.com/'
    ,'Website2','http://google.com/'
    , 'Website3','http://google.com/',
    'Website4','http://google.com/',
    "Website5", 'http://google.com/'];
  @override
  _linkButtonsState createState() => _linkButtonsState(urlList);
}

class _linkButtonsState extends State<linkButtons> {
  final List<String> urlList;

  _linkButtonsState(this.urlList);

  List <Widget> _buttons = [];

  @override
  void initState() {
    super.initState();
    buildLinkButtonList();
  }

  ovalClipIconButton(String url){
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
              image: new AssetImage("assets/Icons/browser.png"),
              width: 32,
              height:32,
              color: null,
              fit: BoxFit.scaleDown,
            ),),
            onTap: () => print("Hello"),
          ),
        ),
      ),
    );
  }

  buildLinkButtonList () {
    List<Widget> buttons= new List();
    for(int i = 0; i<urlList.length; i =i+2){
      Widget b1 = ovalClipIconButton(urlList[i+1]);
      buttons.add(b1);
    }
    setState((){
      _buttons = buttons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: _buttons,
        ),
      )
    );
  }
}
