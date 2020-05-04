import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:signed/widgets/dragbox_widget.dart';


class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int _actualPageNumber = 1, _allPagesCount = 0;
  PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/sample.pdf'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Stack(
              children: <Widget> [
                PdfView(
                  documentLoader: Center(child: CircularProgressIndicator()),
                  pageLoader: Center(child: CircularProgressIndicator()),
                  controller: _pdfController,
                  onDocumentLoaded: (document) {
                    setState(() {
                      _allPagesCount = document.pagesCount;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _actualPageNumber = page;
                    });
                  },
                ),
//                DragBox(Offset(0.0, 0.0), 'Box One', Colors.lime),
//                DragBox(Offset(0.0, 0.0), 'Box One', Colors.lime),
                DragBox(Offset(100.0, 100.0), 'Box Two', Colors.blue.withOpacity(0)),
                DragBox(Offset(100.0, 100.0), 'Box Two', Colors.blue.withOpacity(0)),
                DragBox(Offset(100.0, 100.0), 'Box Two', Colors.blue.withOpacity(0)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward),
              title: Container(),
            ),
          ],
          selectedItemColor: Colors.black54,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: "Select a PDF",
          child:  Icon(Icons.save_alt),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      color: Colors.white,
    );
  }
}
