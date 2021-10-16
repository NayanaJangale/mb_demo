import 'package:softcoremobilebanking/app_data.dart';
import 'package:softcoremobilebanking/constants/menuname.dart';
import 'package:local_auth/local_auth.dart';

import '../handlers/string_handlers.dart';

class Menu {
  int MenuNo;
  String menuName;
  String Status;
  String SubTitle;
  String Header;
  String MenuType;

  List<Menu> accontsMenu = [];
  List<Menu> foundTransferMenu = [];
  List<Menu> rechargeMenu = [];
  List<Menu> utilityMenu = [];
  LocalAuthentication _auth = LocalAuthentication();

  Menu({
    this.MenuNo,
    this.menuName,
    this.Status,
    this.SubTitle,
    this.Header,
    this.MenuType,
  });

  Menu.fromMap(Map<String, dynamic> map) {
    Menu menu = Menu(
      MenuNo: map[MenuConst.MenuNo] ?? 0,
      menuName: map[MenuConst.MenuName] ?? StringHandlers.NotAvailable,
      Status: map[MenuConst.Status] ?? StringHandlers.NotAvailable,
      SubTitle: map[MenuConst.SubTitle] ?? StringHandlers.NotAvailable,
      Header: map[MenuConst.Header] ?? StringHandlers.NotAvailable,
      MenuType: map[MenuConst.MenuType] ?? StringHandlers.NotAvailable,
    );

    switch (map[MenuConst.Header]) {
      case "Accounts":
        AppData.current.accontsMenu.add(menu);
        break;
      case "Funds Transfer":
        AppData.current.fundsTransferMenu.add(menu);
        break;
      case "Recharge / Bill Pays":
        AppData.current.rechargeMenu.add(menu);
        break;
      case "Utilities":
        if (menu.menuName == MenuName.AddFingerprint) {
          _auth.canCheckBiometrics.then((res) {
            if (res) {
              AppData.current.utilityMenu.add(menu);
            }
          });
        } else {
          AppData.current.utilityMenu.add(menu);
        }
        break;
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MenuConst.MenuNo: MenuNo,
        MenuConst.MenuName: menuName,
        MenuConst.Status: Status,
        MenuConst.SubTitle: SubTitle,
        MenuConst.Header: Header,
        MenuConst.MenuType: MenuType,
      };

  Map<String, dynamic> convertToJson() => <String, dynamic>{
        MenuConst.MenuNo: MenuNo,
        MenuConst.MenuName: menuName,
        MenuConst.Status: Status,
        MenuConst.SubTitle: SubTitle,
        MenuConst.Header: Header,
        MenuConst.MenuType: MenuType,
      };
}

class MenuConst {
  static const String MenuNo = "MenuNo";
  static const String MenuName = "MenuName";
  static const String Status = "Status";
  static const String SubTitle = "SubTitle";
  static const String Header = "Header";
  static const String MenuType = "MenuType";
}

class MenuUrls {
  static const String GET_MENUS = "Menu/GetMenu";
}

class SubMenu {
  int actionno, parent;
  String action_desc;

  SubMenu({
    this.actionno,
    this.parent,
    this.action_desc,
  });

  SubMenu.fromMap(Map<String, dynamic> map) {
    actionno = map[SubMenuConst.actionnoConst] ?? 0;
    parent = map[SubMenuConst.parentConst] ?? 0;
    action_desc =
        map[SubMenuConst.action_descConst] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SubMenuConst.actionnoConst: actionno,
        SubMenuConst.parentConst: parent,
        SubMenuConst.action_descConst: action_desc,
      };
}

class SubMenuConst {
  static const String actionnoConst = "actionno";
  static const String action_descConst = "action_desc";
  static const String parentConst = "parent";
}
