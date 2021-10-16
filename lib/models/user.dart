import 'package:softcoremobilebanking/handlers/string_handlers.dart';

class User {

  int UserNo=-1;
  String UserID, DisplayName, LoginPassword, BranchCode, CustomerID, MobileNo;
  bool ChangeLoginPasswordOnNextLogin;

  User({
    this.UserNo,
    this.UserID,
    this.DisplayName,
    this.LoginPassword,
    this.BranchCode,
    this.CustomerID,
    this.MobileNo,
    this.ChangeLoginPasswordOnNextLogin,
  });

  User.fromJson(Map<String, dynamic> map) {
    UserNo = map[UserFieldNames.UserNo] ?? 0;
    UserID = map[UserFieldNames.UserID] ?? StringHandlers.NotAvailable;
    DisplayName = map[UserFieldNames.DisplayName] ?? StringHandlers.NotAvailable;
    LoginPassword = map[UserFieldNames.LoginPassword] ?? StringHandlers.NotAvailable;
    BranchCode = map[UserFieldNames.BranchCode] ?? StringHandlers.NotAvailable;
    CustomerID = map[UserFieldNames.CustomerID] ?? StringHandlers.NotAvailable;
    ChangeLoginPasswordOnNextLogin = map[UserFieldNames.ChangeLoginPasswordOnNextLogin] ??false;
    MobileNo = map[UserFieldNames.MobileNo] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFieldNames.UserNo: UserNo,
        UserFieldNames.UserID: UserID,
        UserFieldNames.DisplayName: DisplayName,
        UserFieldNames.LoginPassword: LoginPassword,
        UserFieldNames.BranchCode: BranchCode,
        UserFieldNames.CustomerID: CustomerID,
        UserFieldNames.MobileNo: MobileNo,
        UserFieldNames.ChangeLoginPasswordOnNextLogin: ChangeLoginPasswordOnNextLogin,
      };
}

class UserFieldNames {
  static const String user = "user";
  static const String UserNo = "UserNo";
  static const String UserID = "UserID";
  static const String DisplayName = "DisplayName";
  static const String ClientName = "ClientName";
  static const String LoginPassword = "LoginPassword";
  static const String TransactionPassword = "TransactionPassword";
  static const String UserType = "UserType";
  static const String AgentCode = "AgentCode";
  static const String MacAddress = "MacAddress";
  static const String CustomerID = "CustomerID";
  static const String MobileNo = "MobileNo";
  static const String ChangeLoginPasswordOnNextLogin =
      "ChangeLoginPasswordOnNextLogin";
  static const String ChangeLoginPasswordReason = "ChangeLoginPasswordReason";
  static const String LoginFailedCount = "LoginFailedCount";
  static const String UserStatus = "UserStatus";
  static const String BlockReason = "BlockReason";
  static const String BlockedOn = "BlockedOn";
  static const String CreatedOn = "CreatedOn";
  static const String AccessPIN = "AccessPIN";
  static const String NewPassword = "NewPassword";
  static const String RegisteredOn = "RegisteredOn";
  static const String img_selfie = "img_selfie";
  static const String SessionAutoID = "SessionAutoID";
  static const String ProductVersion = "ProductVersion";
  static const String Menus = "Menus";
  static const String ConnectionString = "ConnectionString";

  static const String client_code = "client_code";
  static const String ClientCode = "ClientCode";
  static const String BranchCode = "BranchCode";
  static const String bank_name = "school_name";
  static const String logo_url = "logo_url";
  static const String primaryurl = "primaryurl";
  static const String secondaryurl = "secondaryurl";
  static const String tarnaryurl = "tarnaryurl";
  static const String Language = "Language";

  static const String brcode = "brcode";
  static const String Name = "Name";
  static const String PermAddr = "PermAddr";
  static const String TempAddr = "TempAddr";
  static const String DOB = "DOB";
  static const String VoterCardNo = "VoterCardNo";
  static const String AdharNo = "AdharNo";
  static const String PANno = "PANno";
  static const String SMSFlag = "SMSFlag";
  static const String MaritalStatus = "MaritalStatus";
  static const String EduQual = "EduQual";
  static const String Occupation = "Occupation";
  static const String Nominee = "Nominee";
  static const String NRelation = "NRelation";
  static const String NDOB = "NDOB";
  static const String PassPhoto = "PassPhoto";
  static const String IDProof = "IDProof";
  static const String IDProofDoc = "IDProofDoc";
  static const String AddrProof = "AddrProof";
  static const String AddrProofDoc = "AddrProofDoc";
  static const String ApplicationType = "ApplicationType";
  static const String oAccounts = "oAccounts";
}

class UserUrls {
  static const String GET_USER = 'Users/GetEmployeeDetails';
  static const String POST_UNIQUE_ID = 'Users/PostDeviceIdAndPassword';
  static const String CHANGE_PARENT_PASSWORD = 'Users/ChangeEmployeePassword';
}
