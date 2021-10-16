import 'package:softcoremobilebanking/api/circularapi.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/circular.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

class CircularPage extends StatefulWidget {
  const CircularPage({Key key}) : super(key: key);

  @override
  _CircularPageState createState() => _CircularPageState();
}

class _CircularPageState extends State<CircularPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationCntlr;

  List<Circular> circularList = [];
  bool _isLoading;
  String _loadingText;

  @override
  void initState() {
    animationCntlr = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();

    getCirculars();
  }

  @override
  void dispose() {
    animationCntlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
              backgroundColor: ColorsConst.backgroundColor,
              key: scaffoldKey,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  CustomAppbar(
                    backButtonVisibility: true,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                    caption: AppTranslations.of(context).text("key_circular"),
                  ),
                  Expanded(
                    child: circularList != null && circularList.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              getCirculars();
                            },
                            child: ListView.builder(
                              itemCount: circularList.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 0),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = circularList.length;
                                // hotelList.length > 10 ? 10 : hotelList.length;
                                final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: animationCntlr,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn)));
                                animationCntlr.forward();
                                return AnimatedBuilder(
                                  animation: animationCntlr,
                                  builder: (BuildContext context, Widget child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: Transform(
                                        transform: Matrix4.translationValues(
                                            0.0, 50 * (1.0 - animation.value), 0.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, bottom: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30.0),
                                                topLeft: Radius.circular(3.0),
                                                bottomRight: Radius.circular(3.0),
                                                bottomLeft: Radius.circular(3.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Text(
                                                    circularList[index]
                                                        .circular_title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    circularList != null
                                                        ? DateFormat('dd-MMM-yyyy')
                                                            .format(DateTime.parse(
                                                                circularList[index]
                                                                    .entry_date))
                                                        : '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    circularList[index]
                                                        .circular_desc,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : CustomNotFoundWidget(
                            description: AppTranslations.of(context)
                                .text("key_circular_not_available"),
                          ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void getCirculars() {
    setState(() {
      _isLoading = true;
    });

    CircularAPI(context: this.context).getCirculars().then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        circularList =
            List<Circular>.from(data.map((i) => Circular.fromJson(i)));
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }
}
