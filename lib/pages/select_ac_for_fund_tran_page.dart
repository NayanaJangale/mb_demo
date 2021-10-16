import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/components/custom_bank_list.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/constants/beneficiary_type.dart';
import 'package:softcoremobilebanking/constants/first_launch_const.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/customer_beneficiary_details.dart';
import 'package:softcoremobilebanking/pages/select_ifsc_code_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/list_filter_bar.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:showcaseview/showcaseview.dart';

import '../app_data.dart';
import 'add_branch_beneficiary_page.dart';
import 'inter_bank_trasfer_page.dart';
import 'inter_branch_trasfer_page.dart';
import 'menu_help_page.dart';

class SelectAccountForFundTransferPage extends StatefulWidget {
  String beneficiaryType;

  SelectAccountForFundTransferPage({
    this.beneficiaryType,
  });

  @override
  _SelectAccountForFundTransferPageState createState() =>
      _SelectAccountForFundTransferPageState();
}

class _SelectAccountForFundTransferPageState
    extends State<SelectAccountForFundTransferPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController filterController = new TextEditingController();
  bool _isLoading;
  String _loadingText;
  List<CustomerBeneficiaryDetails> customerBenefList = [];
  List<CustomerBeneficiaryDetails> filterBenefList = [];

  GlobalKey addBenefKey = GlobalKey();
  BuildContext myContext;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    filterController.addListener(() {
      if (filterController.text.isNotEmpty) {
        setState(() {
          filterBenefList.clear();
        });
        for (int i = 0; i < customerBenefList.length; i++) {
          if (customerBenefList[i]
                  .BeneficiaryNickName
                  .toLowerCase()
                  .contains(filterController.text.toLowerCase()) ||
              customerBenefList[i]
                  .BeneficiaryAccountNo
                  .toLowerCase()
                  .contains(filterController.text.toLowerCase())) {
            setState(() {
              filterBenefList.add(customerBenefList[i]);
            });
          }
        }
      } else {
        setState(() {
          filterBenefList.clear();
          filterBenefList.addAll(customerBenefList);
        });
      }
    });
    loadBeneficiary();
  }

  @override
  Widget build(BuildContext context) {
    _loadingText = AppTranslations.of(context).text("key_loading");
    return WillPopScope(
      onWillPop: () {
        onBackPressed(context);
      },
      child: CustomProgressHandler(
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
                      onBackPressed(context);
                    },
                    caption: AppTranslations.of(context).text("key_select_account"),
                    icon: Icons.help_outline_outlined,
                    onIconPressed: () async {
                      String menuName,url;
                      String connectionServerMsg = await NetworkHandler
                          .getServerWorkingUrl();
                      if (connectionServerMsg != "key_check_internet") {
                        if (widget.beneficiaryType == BeneficiaryTypeConst.IntraBankBeneficiary) {
                         menuName = AppTranslations.of(context).text("key_intra_bank_trans");
                         url = connectionServerMsg + "/CustCommonAppApi/help/InterBranchTransfer.pdf";
                        } else if (widget.beneficiaryType == BeneficiaryTypeConst
                            .InterBankBeneficiary) {
                          menuName = AppTranslations.of(context).text("key_inter_bank_trans");
                          url = connectionServerMsg + "/CustCommonAppApi/help/InterBankTransfer.pdf";
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MenuHelpPage(
                                  menuName: menuName,
                                  pdfURL:url,
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
                  ListFilterBar(
                    searchFieldController: filterController,
                    onCloseButtonTap: () {
                      setState(() {
                        filterController.text = '';
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: filterBenefList != null && filterBenefList.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              loadBeneficiary();
                            },
                            child: ListView.builder(
                              itemCount: filterBenefList != null
                                  ? filterBenefList.length
                                  : 0,
                              padding: const EdgeInsets.only(top: 5),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5),
                                  child: CustomBankList(
                                    name:
                                        filterBenefList[index].BeneficiaryNickName,
                                    acNo: getAcode(filterBenefList[index]
                                        .BeneficiaryAccountNo),
                                    branchName: widget.beneficiaryType ==
                                            BeneficiaryTypeConst
                                                .IntraBankBeneficiary
                                        ? filterBenefList[index]
                                            .BeneficiaryBranchName
                                        : filterBenefList[index]
                                            .BeneficiaryBankName,
                                    onItemTap: () {
                                      if (widget.beneficiaryType ==
                                          BeneficiaryTypeConst
                                              .InterBankBeneficiary) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => InterBankTransferPage(
                                                    customerBenefDetails:
                                                        filterBenefList[index],
                                                  )),
                                        );
                                      } else if (widget.beneficiaryType ==
                                          BeneficiaryTypeConst
                                              .IntraBankBeneficiary) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  InterBranchTransferPage(
                                                    customerBenefDetails:
                                                        filterBenefList[index],
                                                  )),
                                        );
                                      }
                                    },
                                    onItemLongPress: () {
                                      deleteBenef(context, filterBenefList[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : CustomNotFoundWidget(
                            description: AppTranslations.of(context)
                                .text("key_beneficiary_not_available"),
                          ),
                  ),
                ],
              ),
              floatingActionButton: ShowCaseWidget(
                builder: Builder(builder: (context) {
                  myContext = context;
                  return Showcase(
                    key: addBenefKey,
                    title: AppTranslations.of(context).text("key_add_beneficiary"),
                    description: AppTranslations.of(context).text("key_clk_to_add_benef"),
                    shapeBorder: CircleBorder(),
                    animationDuration: Duration(milliseconds: 1500),
                    overlayColor: Colors.blueGrey,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (widget.beneficiaryType == BeneficiaryTypeConst.IntraBankBeneficiary) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddBeneficiaryPage()),
                          );
                        } else if (widget.beneficiaryType ==
                            BeneficiaryTypeConst.InterBankBeneficiary) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SelectIFSCCodePage()),
                          );
                        }
                      },
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }),
                autoPlay: false,
                autoPlayDelay: Duration(seconds: 3),
                autoPlayLockEnable: false,
              )
            ),
          ),
        ),
      ),
    );
  }

  String getAcode(String accountNo) {
    String acode = '';
    int acVisibleLen = 1;
    if (accountNo.length < 4) {
      acVisibleLen = 1;
    } else {
      acVisibleLen = accountNo.length;
    }
    acode = 'X' * (accountNo.length - acVisibleLen) +
        (accountNo.substring(
            (accountNo.length - acVisibleLen), accountNo.length));
    return acode;
  }

  void deleteBenef(
      BuildContext context, CustomerBeneficiaryDetails beneficiaryDetails) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return new CupertinoAlertDialog(
          title: new Text(
            AppTranslations.of(context)
                .text("key_delete_beneficiary_details"),
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10),
                child: Divider(
                  height: 1.0,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                AppTranslations.of(context)
                    .text("key_do_you_want_delete_beneficiary_details"),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });

                CustomerAPI(context: context)
                    .deleteBeneficiary(
                    CustomerID: beneficiaryDetails.CustomerID,
                    BeneficiaryAccountNo:
                    beneficiaryDetails.BeneficiaryAccountNo)
                    .then((res) {
                  setState(() {
                    _isLoading = false;
                  });
                  if (res != null &&
                      HttpStatusCodes.ACCEPTED == res['Status']) {
                    loadBeneficiary();
                  } else {
                    FlushbarMessage.show(
                      context,
                      res["Message"],
                      MessageTypes.WARNING,
                    );
                  }
                });
              },
              child: Text(
                AppTranslations.of(context).text("key_yes"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppTranslations.of(context).text("key_no"),
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  void loadBeneficiary() {
    setState(() {
      _isLoading = true;
    });
    CustomerAPI(context: context)
        .getActiveBeneficiaries(
            CustomerID: AppData.current.customerLogin.user.CustomerID,
            BeneficiaryType: widget.beneficiaryType)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if(res != null && HttpStatusCodes.OK == res['Status']) {
        var accountsData = res['Data'];
        customerBenefList = List<CustomerBeneficiaryDetails>.from(
            accountsData.map((i) => CustomerBeneficiaryDetails.fromMap(i)));
        if (customerBenefList.length > 0) {
          setState(() {
            filterBenefList.clear();
            filterBenefList.addAll(customerBenefList);
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isFirstLaunch().then((result) {
              print(result);
              if (result) ShowCaseWidget.of(myContext).startShowCase([addBenefKey]);
            });
          });

        } else {
          if (widget.beneficiaryType == BeneficiaryTypeConst.IntraBankBeneficiary) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AddBeneficiaryPage()),
            );
          } else if (widget.beneficiaryType ==
              BeneficiaryTypeConst.InterBankBeneficiary) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SelectIFSCCodePage()),
            );
          }
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

    if (widget.beneficiaryType == BeneficiaryTypeConst.IntraBankBeneficiary) {
      bool isFirstLaunch = AppData.current.preferences
          .getBool(FirstLaunchConst.AddIntraBankBenef) ??
          true;

      if (isFirstLaunch)
        AppData.current.preferences
            .setBool(FirstLaunchConst.AddIntraBankBenef, false);

      return isFirstLaunch;
    } else {
      bool isFirstLaunch = AppData.current.preferences
          .getBool(FirstLaunchConst.AddInterBankBenef) ??
          true;

      if (isFirstLaunch)
        AppData.current.preferences
            .setBool(FirstLaunchConst.AddInterBankBenef, false);

      return isFirstLaunch;
    }
  }

  void onBackPressed(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationHomeScreen(),
      ),
    );
  }
}
