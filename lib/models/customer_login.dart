
import 'package:softcoremobilebanking/handlers/string_handlers.dart';
import 'package:softcoremobilebanking/models/account.dart';
import 'package:softcoremobilebanking/models/menu.dart';
import 'package:softcoremobilebanking/models/user.dart';

class CustomerLogin{
  User user;
  int SessionAutoID=0;
  String ClientName;
  String ConnectionString='';
  String ProductVersion;
  String Language;
  List<Menu> Menus=[];
  List<Account> oAccounts=[];

  CustomerLogin({
    this.user,
    this.SessionAutoID,
    this.ClientName,
    this.ConnectionString,
    this.ProductVersion,
    this.Language,
    this.Menus,
    this.oAccounts,
  });

  CustomerLogin.fromMap(Map<String, dynamic> map) {

    var menuData = map[UserFieldNames.Menus];
    var accountsData = map[UserFieldNames.oAccounts];

    user = User.fromJson(map[UserFieldNames.user]) ?? StringHandlers.NotAvailable;
    SessionAutoID = map[UserFieldNames.SessionAutoID] ?? 0;
    ClientName = map[UserFieldNames.ClientName] ?? StringHandlers.NotAvailable;
    ConnectionString = map[UserFieldNames.ConnectionString] ?? '';
    ProductVersion = map[UserFieldNames.ProductVersion] ?? StringHandlers.NotAvailable;
    Language = map[UserFieldNames.Language] ?? StringHandlers.NotAvailable;
    if(menuData!=null){
      Menus = List<Menu>.from(menuData.map((i) => Menu.fromMap(i)))?? [];
    }
    if(accountsData!=null){
      oAccounts = List<Account>.from(accountsData.map((i) => Account.fromMap(i)))?? [];
    }
  }
  factory CustomerLogin.fromJson(Map<String, dynamic> parsedJson) {
    return CustomerLogin(
      user: parsedJson[UserFieldNames.user] ?? StringHandlers.NotAvailable,
      SessionAutoID: parsedJson[UserFieldNames.SessionAutoID] ?? 0,
      ClientName: parsedJson[UserFieldNames.ClientName] ?? StringHandlers.NotAvailable,
      ConnectionString: parsedJson[UserFieldNames.ConnectionString] ?? '',
      ProductVersion: parsedJson[UserFieldNames.ProductVersion] ?? StringHandlers.NotAvailable,
      Language: parsedJson[UserFieldNames.Language] ?? StringHandlers.NotAvailable,
      Menus: parsedJson[UserFieldNames.Menus] ?? StringHandlers.NotAvailable,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    UserFieldNames.user: user,
    UserFieldNames.SessionAutoID: SessionAutoID,
    UserFieldNames.ClientName: ClientName,
    UserFieldNames.ProductVersion: ProductVersion,
    UserFieldNames.Language: Language,
    UserFieldNames.Menus: Menus,
    UserFieldNames.ConnectionString: ConnectionString,
  };


  Map<String, dynamic> convertToJson() => <String, dynamic>{
    UserFieldNames.user: user,
    UserFieldNames.SessionAutoID: SessionAutoID,
    UserFieldNames.ClientName: ClientName,
    UserFieldNames.ProductVersion: ProductVersion,
    UserFieldNames.Language: Language,
    UserFieldNames.Menus: Menus,
  };
}
class CustomerLoginUrls {
  static const String GET_CustomerLogin = "Customer/CustomerLogin";
  static const String GET_CustomerPhoto = "Customer/GetCustomerPhoto";
  static const String GET_GetClientBanner = "Customer/GetClientBanner";
  static const String GET_GetClientLogo = "Customer/GetClientLogo";
  static const String GET_GetCustomerPhoto = "Customer/GetCustomerPhoto";
  static const String GET_GetAccountsByCustID = "Customer/GetAccountsByCustID";
  static const String GET_GetMenus = "Customer/GetMenus";
}