import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MenuHelpPage extends StatefulWidget {
  String menuName, pdfURL;

  MenuHelpPage({this.menuName, this.pdfURL});

  @override
  _MenuHelpPageState createState() => _MenuHelpPageState();
}

class _MenuHelpPageState extends State<MenuHelpPage> {
  bool isLoading = false;
  String loadingText = 'Loading..';
  final GlobalKey<ScaffoldState> _faqHomeKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: CustomProgressHandler(
        isLoading: this.isLoading,
        loadingText: this.loadingText,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              widget.menuName + AppTranslations.of(context).text("key_help"),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          key: _faqHomeKey,
          body: Container(child: SfPdfViewer.network(widget.pdfURL)),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
