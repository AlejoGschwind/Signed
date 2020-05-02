import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signed/screens/home_screen.dart';
import 'package:signed/widgets/signature_widget.dart';

class SignScreen extends StatefulWidget {
  final Function(File) updateParentFile;

  SignScreen({Key key, this.updateParentFile}) : super(key: key);

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  GlobalKey globalKey = new GlobalKey();
  List<Offset> _points = <Offset>[];
  Storage storage = new Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (_, constraints) {
              return GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  RenderBox object = context.findRenderObject();
                  Offset _localPosition = object.globalToLocal(details.globalPosition);
                  setState(() {
                    _points = new List.from(_points)..add(_localPosition);
                  });
                },
                onPanStart: (DragStartDetails details) => _points.add(details.localPosition),
                onPanEnd: (DragEndDetails details) => _points.add(null),
                child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: RepaintBoundary(
                      key: globalKey,
                      child: CustomPaint(painter: Signature(points: _points)),
                    ),
                  ),
              );
            },
          ),
          Positioned(
            top: 120,
            right: -70,
            child: Transform.rotate(
              angle: -pi/2,
              child: Row(
                children: <Widget>[
//                  _file != null ? Image.file(_file): Container(),
                  Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RaisedButton(
                      child: Text('Save'),
                      color: Colors.white,
                      onPressed: () async {
                        RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
                        ui.Image image = await boundary.toImage();
                        storage.writeFile(image);
                        File fileD = await storage.readFile();
                        widget.updateParentFile(fileD);
//                        Navigator.push(context, MaterialPageRoute(builder: (context) {
//                          return HomeScreen();
//                        }));
                      },
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RaisedButton(
                      child: Text('Cancel'),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      },
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            _points.clear();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//  takeScreenshot() async {
//    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
//    ui.Image image = await boundary.toImage();
//    final directory = (await getApplicationSupportDirectory()).path;
//    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//    Uint8List pngBytes = byteData.buffer.asUint8List();
//    print(directory);
//    File imgFile = new File('$directory/screenshot${rng.nextInt(200)}.png');
//    imgFile.writeAsBytes(pngBytes);
//    onSaveImage('$directory/screenshot${rng.nextInt(200)}.png');
//  }

}

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return new File('$path/signature1.png');
  }

  Future<File> readFile() async {
    try {
      final file = await localFile;
      return file;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<File> writeFile(ui.Image image) async {
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = await localFile;
    imgFile.writeAsBytes(pngBytes);

    return imgFile;
  }
}
