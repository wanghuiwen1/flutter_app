# flutter_app

A new Flutter application.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart' as dom;
import 'package:video_player/video_player.dart';

class NewShow extends StatefulWidget {
  @override
  State createState() => NewShowState();
}

class NewShowState extends State<NewShow> {
  String data =
      '<p><u><em><strong>123</strong></em></u></p> <p style="text-align:center"><span style="font-size:11px"><span style="font-family:黑体">456</span></span></p> <table border="1" cellpadding="1" cellspacing="1" style="width:500px"> <tbody> <tr> <td>1</td> <td>1</td></tr><tr><td>1</td><td>1</td></tr><tr><td>1</td><td>1</td></tr></tbody></table><div style="page-break-after:always"><span style="display:none"></span></div> <p><span style="color:#e67e22"><span style="background-color:#e74c3c">fasdfasdf</span></span></p> <h1>qwe</h1> <h2>qwe</h2> <h3>qweqwea</h3> <h4>asdasdas</h4> <h5>123213</h5> <h6>231231</h6> <p>1</p><pre>qeqweqw</pre><div>asdasd</div><div>adsdasd</div>';

  Widget _buP(dom.Element e) {
    String style = e.attributes['style'];
    if (e.children.length == 0 && e.text == "") {
      print("空p");
    }

    if (style != null) {
      if (style.indexOf("center") > -1) {
        return Center(
          child: Text(e.text),
        );
      }
    }
  }

  TextSpan echoChild(dom.Element e) {
      TextStyle  t=_buildStyle(e); /*new TextStyle()*/;
      print(e.text);
      return TextSpan(text:"qe");
  }

  TextStyle _buildStyle(dom.Element e){
    dom.Element curr=e;
    TextStyle t= new  TextStyle();
    Color color;
    double fontSize;
    String fontFamily;

    while(curr.parent!=null){
      if(curr.localName=="span"){
        String st = curr.attributes['style'];
        if(st.indexOf("font-family")>-1){
          fontFamily= st.split(":")[1];
        }
        if(st.indexOf("color")>-1){
          String c=st.split(":")[1].replaceFirst("#", "0xFF");
          color= new Color(int.parse(c));
        }
        if(st.indexOf("font-size")>-1){
          String c=st.split(":")[1].replaceFirst("px", "");
          fontSize= double.parse(c);
        }
        if(st.indexOf("display:none")>-1){
          if(st.split(":")[1]=="none"){

           }
        }
      }
      curr=curr.parent;
    }
    t=new TextStyle(color: color!=null?color:Theme.of(context).hintColor,
        fontFamily: fontFamily!=null?fontFamily:Theme.of(context).primaryTextTheme.display1.fontFamily,
        fontSize: fontSize!=null?fontSize:Theme.of(context).primaryTextTheme.display1.fontSize);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Html(
            data: data,
            padding: EdgeInsets.all(8.0),
            backgroundColor: Colors.white70,
            defaultTextStyle: TextStyle(fontFamily: 'serif'),
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "video":
                    return new Chewie(
                      new VideoPlayerController.network(
                          'https://media.w3.org/2010/05/sintel/trailer.mp4'),
                      aspectRatio: 3 / 2,
                      autoPlay: true,
                      looping: true,
                    );
                  case "p":
                    return _buP(node);
                  case "span":
                    return _bSpan(node);
                }
              }
            }));
  }

  Widget _bSpan(dom.Element node) {
    dom.Element tmp =node;
    for(int i=0 ; i<tmp.children.length;i++){
      tmp.children[i].remove();
    }
    if (tmp.text!= null&&tmp.text!="") {
      return Center(child: Text("123"),);
    }else{
      return Center(child: Text("123"),);
    }
  }
}

//WebviewScaffold(
//url: "http://192.168.1.123:8080/zw/static/zwapp/news/detail.html?id=8",
//appBar: new AppBar(
//title: new Text("政务新闻"),
//),
//)
