import 'package:softcoremobilebanking/api/loanrecoveryapi.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/loan_request.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_dark_button.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/pages/loan_request_page.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:showcaseview/showcaseview.dart';

import '../app_data.dart';
import 'loan_doc_page.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({Key key}) : super(key: key);

  @override
  _LoanHistoryPageState createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _previousLoanPageGlobalKey =
      new GlobalKey<ScaffoldState>();
  AnimationController animationController;
  List<LoanRequest> loanRequestList = [];
  bool _isLoading;
  String _loadingText;

  GlobalKey addLoanReqKey = GlobalKey();
  BuildContext myContext;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    getLoanRequests();



  }

  @override
  void dispose() {
    animationController.dispose();
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
            key: _previousLoanPageGlobalKey,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                CustomAppbar(
                  backButtonVisibility: true,
                  onBackPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  },
                  caption: AppTranslations.of(context).text("key_prevs_loan_reqst"),
                ),
                Expanded(
                  child: loanRequestList!=null && loanRequestList.length>0? RefreshIndicator(
                    onRefresh: () async{
                      getLoanRequests();
                    },
                    child: ListView.builder(
                      itemCount: loanRequestList.length,
                      padding: const EdgeInsets.only(top: 8),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = loanRequestList.length;
                        // hotelList.length > 10 ? 10 : hotelList.length;
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                        animationController.forward();
                        return AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    0.0, 50 * (1.0 - animation.value), 0.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 10),
                                            child: Icon(
                                              Icons.request_page_rounded,
                                              color: Theme.of(context).primaryColor,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(
                                                left: 00.0, right: 10.0),
                                          ),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        loanRequestList != null
                                                            ? loanRequestList[index]
                                                                .l_tpnm
                                                            : '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark),
                                                        textAlign: TextAlign.start),
                                                  ),
                                                  Text(
                                                      loanRequestList != null
                                                          ? getLoanStatus(
                                                              loanRequestList[index]
                                                                  .aStatus)
                                                          : '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color: getLoanStatusColor(
                                                                  loanRequestList !=
                                                                          null
                                                                      ? getLoanStatus(
                                                                          loanRequestList[
                                                                                  index]
                                                                              .aStatus)
                                                                      : '')),
                                                      textAlign: TextAlign.start),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                      AppTranslations.of(context)
                                                              .text("key_branch") +
                                                          " : " +
                                                          (loanRequestList != null
                                                              ? loanRequestList[index]
                                                                  .Brname
                                                              : ''),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              color:
                                                                  ColorsConst.grey),
                                                      textAlign: TextAlign.start),
                                                  Text(
                                                      loanRequestList != null
                                                          ? DateFormat('dd-MMM-yyyy')
                                                              .format(DateTime.parse(
                                                                  loanRequestList[
                                                                          index]
                                                                      .reqDate))
                                                          : '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              color:
                                                                  ColorsConst.grey),
                                                      textAlign: TextAlign.start),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                      AppTranslations.of(context)
                                                          .text("key_rs_symbol")+(loanRequestList != null
                                                              ? loanRequestList[index]
                                                                  .Amount
                                                                  .toString()
                                                              : '')
                                                          ,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              color:
                                                                  ColorsConst.grey),
                                                      textAlign: TextAlign.start),
                                                  Visibility(
                                                    visible:
                                                        loanRequestList != null &&
                                                            loanRequestList[index]
                                                                    .loanDocuments !=
                                                                null &&
                                                            loanRequestList[index]
                                                                    .loanDocuments
                                                                    .length >
                                                                0,
                                                    child: GestureDetector(
                                                      behavior:
                                                          HitTestBehavior.translucent,
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                LoanDocPage(
                                                              loanDocList:
                                                                  loanRequestList[
                                                                          index]
                                                                      .loanDocuments,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          AppTranslations.of(context)
                                                              .text("key_view_doc"),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .overline
                                                              .copyWith(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                          textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                        ),
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ):CustomNotFoundWidget(
                    description: AppTranslations.of(context)
                        .text("key_prevs_loan_reqst_not_available"),
                  ),
                ),
              ],
            ),
            floatingActionButton: ShowCaseWidget(
              builder: Builder(builder: (context) {
                myContext = context;
                return Showcase(
                  key: addLoanReqKey,
                  title: AppTranslations.of(context).text("key_add_loan_req"),
                  description: AppTranslations.of(context).text("key_clk_to_add_loan_req"),
                  shapeBorder: CircleBorder(),
                  animationDuration: Duration(milliseconds: 1500),
                  overlayColor: Colors.blueGrey,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoanRequestPage()),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }),
              autoPlay: false,
              autoPlayDelay: Duration(seconds: 3),
              autoPlayLockEnable: false,
            ),
          ),
        ),
      ),
    );
  }

  String getLoanStatus(String loanStatus) {
    String loansts = '';
    if (loanStatus == "A") {
      loansts = AppTranslations.of(context).text("key_approved");
    } else if (loanStatus == "R") {
      loansts = AppTranslations.of(context).text("key_rejected");
    } else {
      loansts = AppTranslations.of(context).text("key_pending");
    }
    return loansts;
  }

  Color getLoanStatusColor(String loanStatus) {
    Color color = Colors.grey;
    if (loanStatus == "A") {
      color = Colors.green;
    } else if (loanStatus == "R") {
      color = Colors.red;
    } else {
      color = Colors.orange;
    }
    return color;
  }

  void getLoanRequests(){
    setState(() {
      _isLoading = true;
    });
    LoanRecoveryAPI(context: this.context).GetLoanRequests().then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var data = res["Data"];
        loanRequestList =
        List<LoanRequest>.from(data.map((i) => LoanRequest.fromJson(i)));


        if(loanRequestList !=null && loanRequestList.length>0){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isFirstLaunch().then((result) {
              print(result);
              if (result) ShowCaseWidget.of(myContext).startShowCase([addLoanReqKey]);
            });
          });
        }
      } else {
        FlushbarMessage.show(
          context,
          res["Message"],
          MessageTypes.WARNING,
        );
      }
    });
  }

  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch = AppData.current.preferences
        .getBool(FirstLaunchConst.AddLoanReq) ??
        true;

    if (isFirstLaunch)
      AppData.current.preferences
          .setBool(FirstLaunchConst.AddLoanReq, false);

    return isFirstLaunch;
  }
}
