import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signed/screens/pdf_screen.dart';
import 'package:signed/screens/sign_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _key = GlobalKey();
  File _signatureFile;
  String pathPDF = '';

  updateFileState(File image) {
    setState(() {
      _signatureFile = image;
    });
    print(_signatureFile);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            _signatureFile != null? Image.file(_signatureFile): Container(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignScreen(
                    key: _key,
                    updateParentFile: updateFileState,
                  );
                }));
              },
              child: _signatureFile != null ? Image.file(_signatureFile): Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 250.0,
                decoration: BoxDecoration(
                    border:  Border.all(
                      color: Theme.of(context).accentColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)
                ),
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

