import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signed/screens/pdf_screen.dart';
import 'package:signed/screens/sign_screen.dart';
import 'package:signed/utility.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _key = GlobalKey();
  Image _signature;
  String pathPDF = '';

  @override
  void initState() {
    super.initState();
    loadSignatureFromPreference();
  }

  loadSignatureFromPreference() {
    Utility.getImageFromPreferences().then((img) {
      if (img == null) {
        return;
      }
      setState(() {
        _signature = Utility.imageFromBase64String(img);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignatureScreen(
                    loadSignatureFromPreference,
                  );
                }));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: const Text('Tap to edit Signature.'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(8),
                    height: 250.0,
                    decoration: BoxDecoration(
                        border:  Border.all(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: _signature != null ? _signature : Container(),
                  ),
                ],
              ),
//              child: Container(
//                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                height: 250.0,
//                decoration: BoxDecoration(
//                    border:  Border.all(
//                      color: Theme.of(context).accentColor,
//                      width: 2,
//                    ),
//                    borderRadius: BorderRadius.circular(8)
//                ),
//                child: Row(
//                  children: <Widget>[
//                    _signatureFile != null ? Image.file(_signatureFile): Container(),
//                  ],
//                )
//              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PDFScreen();
          }));
        },
        tooltip: "Select a PDF",
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

