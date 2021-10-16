import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/components/custom_bank_list.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/ifsc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/list_filter_bar.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:showcaseview/showcaseview.dart';

import '../app_data.dart';
import 'add_interbank _beneficiary_page.dart';
import 'menu_help_page.dart';

class SelectIFSCCodePage extends StatefulWidget {
  const SelectIFSCCodePage({Key key}) : super(key: key);

  @override
  _SelectIFSCCodePageState createState() => _SelectIFSCCodePageState();
}

class _SelectIFSCCodePageState extends State<SelectIFSCCodePage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController txtFilterController = new TextEditingController();
  AnimationController animationController;
  List<IFSCCode> ifscCodeList = [];

  GlobalKey searchIFSCKey = GlobalKey();
  BuildContext myContext;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    txtFilterController.addListener(() {
      loadIFSC(txtFilterController.text);
    });
    loadIFSC('');
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                caption: AppTranslations.of(context).text("key_search_ifsc_code"),
                icon: Icons.help_outline_outlined,
                onIconPressed: () async {
                  String connectionServerMsg = await NetworkHandler
                      .getServerWorkingUrl();
                  if (connectionServerMsg != "key_check_internet") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MenuHelpPage(
                              menuName: AppTranslations.of(context).text(
                                  "key_inter_bank_trans"),
                              pdfURL:connectionServerMsg + "/CustCommonAppApi/help/InterBankTransfer.pdf",
                            ),
                      ),
                    );
                  }else{
                    FlushbarMessage.show(
                      context,
                      connectionServerMsg,
                      MessageTypes.WARNING,
                    );
                  }
                },
              ),

              ShowCaseWidget(
                builder: Builder(builder: (context) {
                  myContext = context;
                  return Showcase(
                    key: searchIFSCKey,
                    title: AppTranslations.of(context).text("key_search_ifsc_code"),
                    description: AppTranslations.of(context).text("key_srch_ur_ifsc"),
                    shapeBorder: CircleBorder(),
                    animationDuration: Duration(milliseconds: 1500),
                    overlayColor: Colors.blueGrey,
                    child:  ListFilterBar(
                      searchFieldController: txtFilterController,
                      onCloseButtonTap: () {
                        setState(() {
                          txtFilterController.text = '';
                        });
                        loadIFSC('');
                      },
                    ),
                  );
                }),
                autoPlay: false,
                autoPlayDelay: Duration(seconds: 3),
                autoPlayLockEnable: false,
              ),
              Expanded(
                child: ifscCodeList != null && ifscCodeList.length > 0
                    ? RefreshIndicator(
                        onRefresh: () async {
                          loadIFSC('');
                        },
                        child: ListView.builder(
                          itemCount: ifscCodeList.length,
                          padding: const EdgeInsets.only(top: 5),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count = ifscCodeList.length;
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: CustomBankList(
                                        name: ifscCodeList[index].bank_name,
                                        branchName: AppTranslations.of(context)
                                                .text("key_branch_name") +
                                            " :- " +
                                            ifscCodeList[index].branch_name,
                                        acNo: AppTranslations.of(context)
                                                .text("key_ifsc_code") +
                                            " :- " +
                                            ifscCodeList[index].ifsc_code,
                                        onItemTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AddInterBankBeneficiaryPage(
                                                      bankName: ifscCodeList[index]
                                                          .bank_name,
                                                      city:
                                                          ifscCodeList[index].city,
                                                      ifscCode: ifscCodeList[index]
                                                          .ifsc_code,
                                                      entNo: ifscCodeList[index]
                                                          .ent_no
                                                          .toString(),
                                                    )),
                                          );
                                        },
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
                            .text("key_ifsc_code_not_available"),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadIFSC(String searchText) {
    CustomerAPI(context: context)
        .getIFSCCodes(searchText: searchText)
        .then((res) {
      if (res != null && HttpStatusCodes.OK == res['Status']) {
        var accountsData = res['Data'];
        setState(() {
          ifscCodeList =
              List<IFSCCode>.from(accountsData.map((i) => IFSCCode.fromMap(i)));
          if(ifscCodeList !=null && ifscCodeList.length>0){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isFirstLaunch().then((result) {
                print(result);
                if (result) ShowCaseWidget.of(myContext).startShowCase([searchIFSCKey]);
              });
            });
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
  }


  Future<bool> _isFirstLaunch() async {
    bool isFirstLaunch = AppData.current.preferences
        .getBool(FirstLaunchConst.SearchIFSC) ??
        true;
    if (isFirstLaunch)
      AppData.current.preferences
          .setBool(FirstLaunchConst.SearchIFSC, false);
    return isFirstLaunch;
  }
}
