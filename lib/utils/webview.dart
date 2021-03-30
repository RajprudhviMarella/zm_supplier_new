import 'package:flutter/material.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;
  bool isPdf = false;

  WebViewContainer(this.url, this.title, this.isPdf);

  @override
  createState() => _WebViewContainerState(this.url, this.title, this.isPdf);
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(backgroundColor: Colors.lightBlue);
  }
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _title;
  final _key = UniqueKey();
  bool isPdf = false;

  _WebViewContainerState(this._url, this._title, this.isPdf);

  num position = 1;

  doneLoading() {
    setState(() {
      position = 0;
    });
  }

  startLoading() {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Column(
          children: [
            Body(),
            Expanded(
              child: displayWebView(),
            ),
          ],
        ));
  }

  Widget displayWebView() {
    if (isPdf) {
      return SimplePdfViewerWidget(
        initialUrl: _url,
      );
    } else {
      return WebView(
        key: _key,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: _url,
      );
    }
  }
}
