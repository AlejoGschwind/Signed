import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:signed/screens/home_screen.dart';
import 'package:signed/utility.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature_pad_widget/signature_pad_widget.dart';

class SignatureScreen extends StatefulWidget {
  final Function() loadSignatureFromPreference;

  SignatureScreen(this.loadSignatureFromPreference);

  State<StatefulWidget> createState() {
    return new SignatureScreenState();
  }
}

class SignatureScreenState extends State<SignatureScreen> {
  SignaturePadController _padController;
  bool isSignatureStarted = false;

  void initState() {
    super.initState();
    _padController = new SignaturePadController(onDrawStart: () {
      setState(() {
        isSignatureStarted = true;
      });
    });
  }

  Widget build(BuildContext context) {
    var signaturePad = new SignaturePadWidget(
      _padController,
      new SignaturePadOptions(
          dotSize: 2.0,
          minWidth: 2.0,
          maxWidth: 3.0,
          penColor: "#000000",
          signatureText: "Signed with Signed App."),
    );
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(child: signaturePad),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Transform.rotate(
                  angle: 0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: _handleClear,
                        child: new Text("Clear"),
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                      SizedBox(width: 50,),
                      new RaisedButton(
                        onPressed: isSignatureStarted ? _handleSavePng : null,
                        child: new Text("Save as PNG"),
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleClear() {
    setState(() {
      _padController.clear();
      isSignatureStarted = false;
    });
  }

  Future _handleSavePng() async {
    var result = await _padController.toPng();
    Utility.saveImageToPreferences(Utility.base64String(result));
    this.widget.loadSignatureFromPreference();
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return HomeScreen();
        },
      ),
    );
  }
}