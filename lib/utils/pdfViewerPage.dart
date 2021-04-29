import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:ui';

import 'color.dart';

/**
 * Created by RajPrudhviMarella on 29/Apr/2021.
 */

class PdfViewerPage extends StatefulWidget {
  String pdfUrl;

  PdfViewerPage(this.pdfUrl);

  @override
  State<StatefulWidget> createState() {
    return PdfViewDesign();
  }
}

class PdfViewDesign extends State<PdfViewerPage> with TickerProviderStateMixin {
  bool _isLoading = true;
  String pdfOriginalPath = "";

  @override
  void initState() {
    super.initState();
    _downloadAndShare().then(
      (value) => {
        setState(() {
          if (value != null) {
            pdfOriginalPath = value.path;
            _isLoading = false;
          } else {
            _isLoading = true;
          }
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: faintGrey,
        appBar: buildAppBar(context),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: faintGrey,
                padding: EdgeInsets.all(15),
                child: PDFView(
                  filePath: pdfOriginalPath,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  swipeHorizontal: true,
                  nightMode: false,
                ),
              ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: new Text(
          "PDF",
          style: new TextStyle(
              color: Colors.black,
              fontFamily: "SourceSansProBold",
              fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Share.shareFiles([pdfOriginalPath]);
            },
          ),
        ]);
  }

  Future<File> _downloadAndShare() async {
    var fileName =
        DateFormat('yyyyMMddHHmmss').format(new DateTime.now()).toString();
    try {
      var data = await http.get(Uri.parse(widget.pdfUrl));
      var bytes = data.bodyBytes;
      Directory dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      File urlFile = await file.writeAsBytes(bytes);
      print("File saved" + data.statusCode.toString());
      print(dir.path);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file" + e.toString());
    }
  }
}
