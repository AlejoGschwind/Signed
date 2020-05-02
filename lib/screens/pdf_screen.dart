import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:extended_image/extended_image.dart';


class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PdfPageImage _pageImage;
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl();
  }

  void createFileOfPdfUrl() async {
    final document = await PdfDocument.openAsset('assets/sample.pdf');
    final page = await document.getPage(1);
    _pageImage = await page.render(width: page.width, height: page.height);
    setState(() {});
    await page.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ExtendedImage.memory(
            _pageImage.bytes,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: true,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
        ),
      ),
      color: Colors.white,
    );
  }
}
