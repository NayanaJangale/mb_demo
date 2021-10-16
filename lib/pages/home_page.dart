import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:softcoremobilebanking/api/configurationapi.dart';
import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/components/auto_update_dialog.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/components/fundtransfer_view.dart';
import 'package:softcoremobilebanking/components/receipt.dart';
import 'package:softcoremobilebanking/constants/SharedPreferencesConst.dart';
import 'package:softcoremobilebanking/constants/beneficiary_type.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/constants/service_type_constant.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/pages/accounts_page.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_fund_tran_page.dart';
import 'package:softcoremobilebanking/pages/select_ac_for_self_transfer_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:launch_review/launch_review.dart';
import 'package:showcaseview/showcaseview.dart';

import '../app_data.dart';
import 'account_statement_page.dart';
import 'loan_history_page.dart';
import 'more_menu_page.dart';
import 'recent_bill_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  bool multiple = true;
  PageController controller;
  final GlobalKey<ScaffoldState> _HomePageGlobalKey =
      new GlobalKey<ScaffoldState>();
  final pageIndexNotifier = ValueNotifier<int>(0);
  int _currentIndex = 0;
  Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  Uint8List bytesLogoImg;
  String clientLogo = '';
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();

  Account account;
  bool _isLoading;
  String _loadingText;

  @override
  void initState() {
    _isLoading = false;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    getConfiguration();
    if (AppData.current.customerLogin.oAccounts == null ||
        AppData.current.customerLogin.oAccounts.length == 0) {
      setState(() {
        _isLoading = true;
      });
      CustomerAPI(context: context)
          .getAccounts(
              CustomerID: AppData.current.customerLogin.user.CustomerID)
          .then((res) {
        setState(() {
          _isLoading = false;
        });
        if (res != null && HttpStatusCodes.OK == res['Status']) {
          var accountsData = res['Data'];
          AppData.current.customerLogin.oAccounts =
              List<Account>.from(accountsData.map((i) => Account.fromMap(i)));
          setState(() {
            if (AppData.current.customerLogin != null &&
                AppData.current.customerLogin.oAccounts.length > 0) {
              account = AppData.current.customerLogin.oAccounts[0];
            }
          });
        } else {
          FlushbarMessage.show(
            context,
            res["Message"],
            MessageTypes.WARNING,
          );
        }
      });
    } else {
      account = AppData.current.customerLogin.oAccounts[0];
    }

    getClientBannerImgUrl().then((res) {
      if (res != '') {
        AppData.current.preferences
            .setString(SharedPreferencesConst.ClientBanner, res);
      }
    });
    getClientLogoImgUrl().then((res) {
      if (res != '') {
        AppData.current.preferences
            .setString(SharedPreferencesConst.ClientLogo, res);
        setState(() {
          bytesLogoImg = Base64Decoder().convert(res);
          AppData.current.bytesLogoImg = bytesLogoImg;
        });
      }
    });
    super.initState();
    controller = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        if (result) ShowCaseWidget.of(context).startShowCase([_one, _two]);
      });
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
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
      child: Scaffold(
          backgroundColor: ColorsConst.backgroundColor,
          key: _HomePageGlobalKey,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.only(
                        top: AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top +
                            24,
                        bottom: 10 + MediaQuery.of(context).padding.bottom,
                      ),
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        animationController.forward();
                        return Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    AppTranslations.of(context)
                                        .text("key_account_overview"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            //   color: Theme.of(context).primaryColorDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 140,
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 30, right: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'X' *
                                                    (account != null
                                                        ? account.AccountNo
                                                                .length -
                                                            6
                                                        : 1) +
                                                (account != null
                                                    ? account.AccountNo
                                                        .substring(account
                                                                .AccountNo
                                                                .length -
                                                            6)
                                                    : ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: ColorsConst.white,
                                                ),
                                          ),
                                          Spacer(),
                                          Text(
                                            account != null
                                                ? account.AcType
                                                : '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    color: ColorsConst.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppTranslations.of(context)
                                            .text("key_balance"),
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsConst.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        AppTranslations.of(context)
                                                .text("key_rs_symbol") +
                                            (account != null
                                                ? account.Balance.toString()
                                                : ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsConst.white,
                                              fontSize: 14,
                                            ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Spacer(),
                                          Showcase(
                                              key: _one,
                                              title: AppTranslations.of(context)
                                                  .text("key_account_details"),
                                              description: AppTranslations.of(
                                                      context)
                                                  .text(
                                                      "key_clck_to_view_ac_stmt"),
                                              shapeBorder: CircleBorder(),
                                              animationDuration:
                                                  Duration(milliseconds: 1500),
                                              overlayColor: Colors.blueGrey,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AccountsPage(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppTranslations.of(context)
                                                      .text("key_view_all"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline
                                                      .copyWith(
                                                          color:
                                                              ColorsConst.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).buttonColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topRight: Radius.circular(50.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              ColorsConst.grey.withOpacity(0.6),
                                          offset: Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getOprUI(),
                                Visibility(
                                  visible:
                                      AppData.current.fundsTransferMenu.length >
                                          0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          AppTranslations.of(context)
                                              .text("key_tran_money"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  //   color: Theme.of(context).primaryColorDark,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 150,
                                        child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 0,
                                              right: 16,
                                              left: 0),
                                          itemCount: AppData.current
                                                      .fundsTransferMenu !=
                                                  null
                                              ? AppData.current
                                                  .fundsTransferMenu.length
                                              : 0,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Animation<
                                                double> animation = Tween<
                                                        double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                                    parent: animationController,
                                                    curve: Interval(
                                                        (1 /
                                                                AppData
                                                                    .current
                                                                    .fundsTransferMenu
                                                                    .length) *
                                                            index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn)));
                                            animationController.forward();

                                            return FundTransferView(
                                              menu: AppData.current
                                                  .fundsTransferMenu[index],
                                              animation: animation,
                                              animationController:
                                                  animationController,
                                              onPressed: () {
                                                if (AppData
                                                        .current
                                                        .fundsTransferMenu[
                                                            index]
                                                        .menuName
                                                        .toUpperCase() ==
                                                    MenuName.SelfAccountTransfer
                                                        .toUpperCase()) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          SelectAccountForSelfTransferPage(),
                                                    ),
                                                  );
                                                } else if (AppData
                                                        .current
                                                        .fundsTransferMenu[
                                                            index]
                                                        .menuName
                                                        .toUpperCase() ==
                                                    MenuName.IntraBankTransfer
                                                        .toUpperCase()) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          SelectAccountForFundTransferPage(
                                                        beneficiaryType:
                                                            BeneficiaryTypeConst
                                                                .IntraBankBeneficiary,
                                                      ),
                                                    ),
                                                  );
                                                } else if (AppData
                                                        .current
                                                        .fundsTransferMenu[
                                                            index]
                                                        .menuName
                                                        .toUpperCase() ==
                                                    MenuName.InterBankTransfer
                                                        .toUpperCase()) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          SelectAccountForFundTransferPage(
                                                        beneficiaryType:
                                                            BeneficiaryTypeConst
                                                                .InterBankBeneficiary,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.white,
                                  child: CarouselSlider(
                                    items: CarouselSliderList(
                                      _getImageSliderList(),
                                    ),
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                          print(_currentIndex);
                                        });
                                      },
                                      height: 150,
                                      aspectRatio: 5,
                                      viewportFraction: 1.0,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(minutes: 3),
                                      autoPlayAnimationDuration:
                                          Duration(minutes: 8),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                  visible: AppData.current.rechargeMenu !=
                                          null &&
                                      AppData.current.rechargeMenu.length > 0,
                                  child: Text(
                                      AppTranslations.of(context)
                                          .text("key_recharge_pay_bills"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              //   color: Theme.of(context).primaryColorDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                ),
                                _billAndRechargeWidget(),
                              ],
                            ));
                      },
                    ),
                  )
                ],
              ),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          )),
    );
  }

  void getConfiguration() {
    double version = 0;
    setState(() {
      _isLoading = true;
    });
    ConfigurationAPI(context: context).getConfiguration().then((res) {
      setState(() {
        _isLoading = false;
      });
        var data = res['Data'];
      if (Platform.isIOS) {
        version= double.parse(data['IOSVersion']);
      } else {
        version= double.parse(data['Version']);
      }

        if (data != null &&
            data != '' &&
            version > ProjectSettings.AppVersion) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return WillPopScope(
                  onWillPop: _onBackPressed,
                  child: AutoUpdateDialog(
                    message: AppTranslations.of(context)
                        .text("key_auto_update_instruction"),
                    onOkayPressed: () {
                      LaunchReview.launch(
                        androidAppId: "in.mb.demo",
                        iOSAppId: "",
                      );
                    },
                  ),
                );
              });
        }
    });
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsConst.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              ColorsConst.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 60, top: 0, bottom: 10),
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(0),
                                  // color:  Colors.grey[200],
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                                AppData.current.customerLogin
                                                        .ClientName ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        // color: Theme.of(context).primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15))
                                          ],
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: ColorsConst.white,
                                        radius: 20,
                                        child: bytesLogoImg == null
                                            ? Image.asset(
                                                'assets/images/logo.png',
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                              )
                                            : Image.memory(
                                                bytesLogoImg,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                fit: BoxFit.fitWidth,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  List<ImageSliderModel> _getImageSliderList() {
    List<ImageSliderModel> list = new List();

    list.add(new ImageSliderModel("assets/images/real.jpg"));
    list.add(new ImageSliderModel("assets/images/real.jpg"));
    list.add(new ImageSliderModel("assets/images/real.jpg"));
    list.add(new ImageSliderModel("assets/images/real.jpg"));

    return list;
  }

  CarouselSliderList(List<ImageSliderModel> getImageSliderList) {
    return getImageSliderList.map((i) {
      return Builder(builder: (BuildContext context) {
        return imageSliderItem(i);
      });
    }).toList();
  }

  Widget imageSliderItem(ImageSliderModel i) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/banner.png",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget rechargeMenuView({IconData icon, String text, Function onPressed}) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: ColorsConst.white.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(14)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.white.withOpacity(0.4), //Color(0xfff3f3f3),
                      offset: Offset(5, 5),
                      blurRadius: 10)
                ]),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Flexible(
          child: Text(
            StringUtils.capitalize(text, allWords: true),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      ],
    );
  }

  Widget getOprUI() {
    bool isLoanReqMenu = false;
    isLoanReqMenu = AppData.current.accontsMenu
        .where((x) => x.menuName.toUpperCase().contains(MenuName.LoanRequest))
        .isNotEmpty;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            AppTranslations.of(context).text("key_services"),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.caption.copyWith(
                //   color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              getButtonUI(
                  text: AppTranslations.of(context).text("key_ac_statement"),
                  onPreesed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountStatementPage(),
                      ),
                    );
                  }),
              const SizedBox(
                width: 10,
              ),
              Visibility(
                visible: isLoanReqMenu,
                child: getButtonUI(
                    text: AppTranslations.of(context).text("key_loan_req"),
                    onPreesed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoanHistoryPage(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              Showcase(
                key: _two,
                title: AppTranslations.of(context).text("key_menu"),
                description:
                    AppTranslations.of(context).text("key_clk_to_view_servc"),
                shapeBorder: CircleBorder(),
                animationDuration: Duration(milliseconds: 1500),
                overlayColor: Colors.blueGrey,
                child: getButtonUI(
                    text: AppTranslations.of(context).text("key_more"),
                    onPreesed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MoreMenuPage(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getButtonUI({String text, Function onPreesed}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            color: false
                ? Theme.of(context).primaryColor
                : ColorsConst.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(14.0)),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          onTap: onPreesed,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.27,
                color: false
                    ? ColorsConst.nearlyWhite
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _billAndRechargeWidget() {
    String serviceType;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      // to disable GridView's scrolling
      shrinkWrap: true,
      itemCount: AppData.current.rechargeMenu.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 1.2),
      ),
      itemBuilder: (BuildContext context, int index) {
        return rechargeMenuView(
            icon: AppData.current.getMenuIcon(
                context: context,
                menuName: AppData.current.rechargeMenu[index].menuName),
            text: AppData.current.getMenuName(
                context: context,
                menuName: AppData.current.rechargeMenu[index].menuName),
            onPressed: () {
              switch (AppData.current.rechargeMenu[index].menuName) {
                case MenuName.RecentBills:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: "%",
                          paymentStatus: "%",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.RecentBills,
                          serviceName: "%"),
                    ),
                  );
                  break;
                case MenuName.MobileRecharge:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PrepaidRecharge;
                  } else {
                    serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.MobileRecharge,
                          serviceName: ServiceNameConst.Mobile),
                    ),
                  );

                  break;
                case MenuName.DataCardRecharge:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PrepaidRecharge;
                  } else {
                    serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.DataCardRecharge,
                          serviceName: ServiceNameConst.DataCard),
                    ),
                  );
                  break;
                case MenuName.DTHRecharge:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PrepaidRecharge;
                  } else {
                    serviceType = ServiceTypeConst.Pay2NewPrepaidRecharge;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.DTHRecharge,
                          serviceName: ServiceNameConst.DTH),
                    ),
                  );
                  break;
                case MenuName.PostpaidMobileBills:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PostpaidBills;
                  } else {
                    serviceType = ServiceTypeConst.Pay2NewPostpaidBills;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.PostpaidMobileBills,
                          serviceName: ServiceNameConst.Mobile),
                    ),
                  );
                  break;
                case MenuName.LandlinePhoneBills:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PostpaidBills;
                  } else {
                    // serviceType = ServiceNameConst.Landline;
                    serviceType = ServiceTypeConst.Pay2NewPostpaidBills;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.LandlinePhoneBills,
                          serviceName: ServiceNameConst.Landline),
                    ),
                  );
                  break;
                case MenuName.ElectricityBills:
                  if (AppData.current.rechargeMenu[index].MenuType ==
                      MenuTypeConst.Cyberplat) {
                    serviceType = ServiceTypeConst.PostpaidBills;
                  } else {
                    serviceType = ServiceTypeConst.Electricity;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecentBillsPage(
                          serviceType: serviceType,
                          paymentStatus: "SUCCESS",
                          menuType:
                              AppData.current.rechargeMenu[index].MenuType,
                          menuFor: MenuName.ElectricityBills,
                          serviceName: ServiceNameConst.Electricity),
                    ),
                  );
                  break;
              }
            });
      },
    );
  }

  Future<String> getClientBannerImgUrl() async {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri uri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            CustomerLoginUrls.GET_GetClientBanner,
      ).replace(queryParameters: {
        "ClientCode": AppData.current.ClientCode,
        "ConnectionString": AppData.current.ConnectionString,
      });
      Response response = await get(
        uri,
      );
      if (response.statusCode != HttpStatusCodes.OK) {
        return '';
      } else {
        return base64Encode(response.bodyBytes);
      }
    }
  }

  Future<String> getClientLogoImgUrl() async {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri uri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            CustomerLoginUrls.GET_GetClientLogo,
      ).replace(queryParameters: {
        "ClientCode": AppData.current.ClientCode,
        "ConnectionString": AppData.current.ConnectionString,
      });

      Response response = await get(
        uri,
      );
      if (response.statusCode != HttpStatusCodes.OK) {
        return '';
      } else {
        return base64Encode(response.bodyBytes);
      }
    }
  }

  Future<bool> _onBackPressed() {
    exit(1);
  }

  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch =
        AppData.current.preferences.getBool(FirstLaunchConst.HomePage) ?? true;

    if (isFirstLaunch)
      AppData.current.preferences.setBool(FirstLaunchConst.HomePage, false);

    return isFirstLaunch;
  }
}

class ImageSliderModel {
  String _path;

  ImageSliderModel(this._path);

  String get path => _path;

  set path(String value) {
    _path = value;
  }
}
