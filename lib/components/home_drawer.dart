import 'package:cached_network_image/cached_network_image.dart';
import 'package:softcoremobilebanking/api/customerapi.dart';
import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/constants/http_status_codes.dart';
import 'package:softcoremobilebanking/constants/message_types.dart';
import 'package:softcoremobilebanking/constants/project_settings.dart';
import 'package:softcoremobilebanking/handlers/network_handler.dart';
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/localization/app_translations.dart';
import 'package:softcoremobilebanking/models/customer_login.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:softcoremobilebanking/pages/login_page.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:flutter/material.dart';
import 'flushbar_message.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex,
    this.menuLen,
  }) : super(key: key);

  final AnimationController iconAnimationController;
  final int screenIndex, menuLen;
  final Function(Menu) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder<String>(
                      future: getCustImageUrl(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(1.0 -
                                  (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(
                                    Tween<double>(begin: 0.0, end: 24.0)
                                            .animate(CurvedAnimation(
                                                parent: widget
                                                    .iconAnimationController,
                                                curve: Curves.fastOutSlowIn))
                                            .value /
                                        360),
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(60.0)),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.network(
                                            snapshot.data.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0,
                                            right: 60.0,
                                            top: 60.0,
                                            bottom: 60.0),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                        AppData.current.customerLogin.user != null
                            ? AppData.current.customerLogin.user.DisplayName
                            : '',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).primaryColor.withOpacity(0.6),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (AppData.current.accontsMenu.length > 0)
                    ExpansionTile(
                      iconColor: ColorsConst.grey,
                      collapsedIconColor: Theme.of(context).primaryColorDark,
                      //tilePadding: EdgeInsets.only(left: 10),
                      childrenPadding: EdgeInsets.only(left: 5),

                      leading: Icon(Icons.account_balance_outlined,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      // collapsedBackgroundColor: ColorsConst.white,
                      // Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                      //    backgroundColor: ColorsConst.white,
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        child: Text(
                          AppTranslations.of(context).text("key_accounts"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              ),
                        ),
                      ),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(
                            AppData.current.accontsMenu,
                          ),
                        ),
                      ],
                    ),
                  if (AppData.current.fundsTransferMenu.length > 0)
                    ExpansionTile(
                      iconColor: ColorsConst.grey,
                      collapsedIconColor: Theme.of(context).primaryColorDark,
                      leading: Icon(Icons.money_rounded,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      // collapsedBackgroundColor: ColorsConst.white,
                      // backgroundColor: ColorsConst.white,
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        child: new Text(
                          AppTranslations.of(context)
                              .text("key_funds_transfer"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              ),
                        ),
                      ),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(
                            AppData.current.fundsTransferMenu,
                          ),
                        ),
                      ],
                    ),
                  if (AppData.current.rechargeMenu.length > 0)
                    ExpansionTile(
                      iconColor: ColorsConst.grey,
                      collapsedIconColor: Theme.of(context).primaryColorDark,
                      leading: Icon(Icons.mobile_friendly_rounded,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      // collapsedBackgroundColor: ColorsConst.white,
                      // backgroundColor: ColorsConst.white,
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        child: new Text(
                          AppTranslations.of(context)
                              .text("key_recharge_bill_pay"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              ),
                        ),
                      ),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(
                            AppData.current.rechargeMenu,
                          ),
                        ),
                      ],
                    ),

                  /*Divider(
                    height: 1,
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),*/
                  if (AppData.current.utilityMenu.length > 0)
                    ExpansionTile(
                      iconColor: ColorsConst.grey,
                      collapsedIconColor: Theme.of(context).primaryColorDark,
                      leading: Icon(Icons.settings,
                          size: 20, color: Theme.of(context).primaryColorDark),
                      // collapsedBackgroundColor: ColorsConst.white,
                      //backgroundColor: ColorsConst.white,
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        child: new Text(
                          AppTranslations.of(context).text("key_utilites"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              ),
                        ),
                      ),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(
                            AppData.current.utilityMenu,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
          Divider(
            height: 1,
            color: Theme.of(context).primaryColor.withOpacity(0.6),
          ),
          ListTile(
            onTap: () {
              onLogoutPressed();
            },
            title: Text(
              AppTranslations.of(context).text("key_logout"),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).primaryColorDark,
                  ),
              textAlign: TextAlign.left,
            ),
            trailing: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }

  _buildExpandableContent(List<Menu> menuList) {
    List<Widget> columnContent = [];

    for (Menu menu in menuList)
      columnContent.add(
        GestureDetector(
          onTap: () {
            navigationtoScreen(menu);
          },
          child: Container(
            padding: EdgeInsets.only(left: 30),
            child: new ListTile(
              contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              title: new Text(
                StringHandlers.capitalizeWords(
                    AppData.current
                        .getMenuName(context: context, menuName: menu.menuName),
                ),
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  // color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              // leading: new Icon(Icons.ac_unit),
            ),
          ),
        ),
      );
    return columnContent;
  }

  Future<void> navigationtoScreen(Menu menu) async {
    widget.callBackIndex(menu);
  }

  Future<String> getCustImageUrl() =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                CustomerLoginUrls.GET_CustomerPhoto,
          ).replace(queryParameters: {
            "ClientCode": AppData.current.ClientCode,
            "ConnectionString": AppData.current.ConnectionString,
            "CustomerID": AppData.current.customerLogin.user.CustomerID,
          }).toString();
        }
      });

  onLogoutPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(//imps 2lakh neft rtgs 5lakh gold current account // 2lkh imps 3 lkh neft/ rtgs gold sav a/c   //
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              //height: MediaQuery.of(context).size.height * 3 / 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppTranslations.of(context)
                          .text("key_do_you_want_to_logout"),
                      style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[500],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              AppTranslations.of(context).text("key_no"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              CustomerAPI(context: context)
                                  .CustomerLogout()
                                  .then((res) {

                                if (res != null &&
                                    HttpStatusCodes.ACCEPTED == res['Status']) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage(),
                                    ),
                                        (route) => false,
                                  );
                                } else {
                                  FlushbarMessage.show(
                                    context,
                                    res["Message"],
                                    MessageTypes.WARNING,
                                  );
                                  Navigator.pop(context);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[500],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              AppTranslations.of(context).text("key_yes"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
