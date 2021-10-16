import 'package:softcoremobilebanking/components/custom_bank_list.dart';
import 'package:softcoremobilebanking/components/custom_not_found_wiget.dart';
import 'package:softcoremobilebanking/components/flushbar_message.dart';
import 'package:softcoremobilebanking/components/list_filter_bar.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/pages/self_account_trasfer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/pages/navigation_home_screen.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';

import '../app_data.dart';
import 'menu_help_page.dart';

class SelectAccountForSelfTransferPage extends StatefulWidget {
  @override
  _SelectAccountForSelfTransferPageState createState() =>
      _SelectAccountForSelfTransferPageState();
}

class _SelectAccountForSelfTransferPageState
    extends State<SelectAccountForSelfTransferPage> {
  final GlobalKey<ScaffoldState> scafoldGlobalKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController filterController = new TextEditingController();
  List<Account> creditableAccounts = [];
  List<Account> filterAccounts = [];
  Account selectedAc;

  @override
  void initState() {
    super.initState();

    if (AppData.current.customerLogin != null &&
        AppData.current.customerLogin.oAccounts != null &&
        AppData.current.customerLogin.oAccounts.length > 0) {
      creditableAccounts = AppData.current.customerLogin.oAccounts
          .where((i) => i.AccountName != AccountType.FixedDepositAccount)
          .toList();
      filterAccounts.addAll(creditableAccounts);

      if (creditableAccounts.length > 0) selectedAc = filterAccounts[0];
    }

    filterController.addListener(() {
      if (filterController.text.isNotEmpty) {
        setState(() {
          filterAccounts.clear();
        });
        for (int i = 0; i < creditableAccounts.length; i++) {
          if (creditableAccounts[i]
                  .AccountName
                  .toLowerCase()
                  .contains(filterController.text.toLowerCase()) ||
              creditableAccounts[i]
                  .AccountNo
                  .toLowerCase()
                  .contains(filterController.text.toLowerCase())) {
            setState(() {
              filterAccounts.add(creditableAccounts[i]);
            });
          }
        }
      } else {
        setState(() {
          filterAccounts.clear();
          filterAccounts.addAll(creditableAccounts);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorsConst.backgroundColor,
          key: scafoldGlobalKey,
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
                caption: AppTranslations.of(context).text("key_select_account"),
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
                                  "key_self_ac_transfer"),
                              pdfURL:connectionServerMsg + "/CustCommonAppApi/help/selfactransfer.pdf",
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
                    filterAccounts.clear();
                    filterAccounts.addAll(creditableAccounts);
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: filterAccounts != null && filterAccounts.length > 0
                    ? ListView.builder(
                        itemCount: filterAccounts.length,
                        padding: const EdgeInsets.only(top: 5),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            child: CustomBankList(
                              name: filterAccounts[index].AccountName,
                              acNo: filterAccounts[index].AccountNo,
                              branchName: filterAccounts[index].BranchDisplayName,
                              onItemTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SelfAccountTransferPage(
                                      creditAccount: filterAccounts[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : CustomNotFoundWidget(
                        description: AppTranslations.of(context)
                            .text("key_account_not_available"),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
