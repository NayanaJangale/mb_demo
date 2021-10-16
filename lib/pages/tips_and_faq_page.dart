
import 'package:flutter/material.dart';
import 'package:softcoremobilebanking/components/custom_app_bar.dart';
import 'package:softcoremobilebanking/components/custom_progress_handler.dart';
import 'package:softcoremobilebanking/pages/settings_page.dart';
import 'package:softcoremobilebanking/themes/colors.dart';
import 'package:softcoremobilebanking/pages/welcome_page.dart';

class TipsAndFAQPage extends StatefulWidget {
  String menuFor;

  TipsAndFAQPage({
    this.menuFor,
  });

  @override
  _TipsAndFAQPageState createState() => _TipsAndFAQPageState();
}

class _TipsAndFAQPageState extends State<TipsAndFAQPage> {
  bool _isLoading, isMarathi = true;
  String _loadingText;
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  var data = [];

  var tips = [
    {
      "title": "Security",
      "title_mr": "सुरक्षा",
      "sub_title": [
        "Set up a Pin/password to access the handset menu on your mobile phone.",
        "Pin/Password must be complex and difficult to predict.",
        "Change password frequently."
      ],
      "sub_title_mr": [
        "आपल्या मोबाइल फोनवरील हँडसेट मेनूमध्ये प्रवेश करण्यासाठी एक पिन / संकेतशब्द सेट करा",
        "पिन / संकेतशब्द जटिल असावा जेणे करून पिन / संकेतशब्द अंदाज करणे कठीण होईल. ",
        "संकेतशब्द वारंवार बदला."
      ]
    },
    {
      "title": "Precaution",
      "title_mr": "खबरदारी",
      "sub_title": [
        "Do not follow any URL in message that you are not sure about.",
      ],
      "sub_title_mr": [
        "आपल्याला खात्री नसलेल्या संदेशामधील कोणतीही लिंक ला क्लिक करू नका",
      ]
    },
    {
      "title": "Clean Up",
      "title_mr": "क्लीन अप",
      "sub_title": [
        "Delete junk message and chain messages regularly.",
      ],
      "sub_title_mr": [
        "नियमितपणे जंक संदेश आणि चेन संदेश हटवा",
      ]
    },
    {
      "title": "Protection",
      "title_mr": "संरक्षण",
      "sub_title": [
        "Protect your mobile device to protect against unauthorised access. Set up a Pin/password that is difficult to crack.",
        "Do not enable auto-fill or save user IDs or passwords for mobile banking online.",
        "If possible, maximise the security features by enabling encryption, remote wipe and location tracking on device.",
        "Turn off wireless device services such as Wi-Fi, Bluetooth and GPS when they are not being used.",
        "Avoid using unsecured Wi-Fi, public or shared networks.",
        "Log out from online mobile banking or application as soon as you have completed your transactions.",
        "Be aware of shoulder surfers. Be extra careful while typing confidential information such as your account details and password on your mobile in public places.",
      ],
      "sub_title_mr": [
        "अनधिकृत प्रवेशापासून संरक्षण करण्यासाठी आपल्या मोबाइल डिव्हाइसचे संरक्षण करा. एक पिन / संकेतशब्द सेट करा ज्यास क्रॅक करणे कठीण असेल.",
        "ऑनलाईन मोबाइल बँकिंगसाठी ऑटो-फील किंवा वापरकर्ता आयडी किंवा संकेतशब्द जतन करणे अक्षम करा",
        "शक्य असल्यास, डिव्हाइसवर एन्क्रिप्शन, रिमोट वाइप आणि स्थान ट्रॅक सक्षम करून सुरक्षा वैशिष्ट्ये वाढवा",
        "वायरलेस डिव्हाइस सेवा जसे वाय-फाय, ब्लूटूथ आणि जीपीएस गरज नसताना बंद करा",
        "असुरक्षित वाय-फाय, सार्वजनिक किंवा सामायिक नेटवर्क वापरणे टाळा",
        "आपण आपले व्यवहार पूर्ण होताच ऑनलाइन मोबाइल बँकिंग किंवा अनुप्रयोगामधून लॉग आउट करा.",
        "आपल्या मोबाइलवर सार्वजनिक ठिकाणी आपल्या खात्याचा तपशील आणि संकेतशब्द यासारखी गोपनीय माहिती टाइप करताना अतिरिक्त काळजी घ्या",
      ],
    },
    {
      "title": "Accessibility",
      "title_mr": "सुलभता",
      "sub_title": [
        "If you have to send your mobile for repair/maintenance, Do following things.",
        "Clear the browsing history.",
        "Clear cache and temporary files stored in the memory as they may contain your account numbers and other sensitive information.",
        "Block your mobile banking applications by contacting your bank. You can unblock them when you get the mobile back.",
        "Do not save confidential information such as your debit/credit card numbers, CVV numbers or PIN’s on your mobile phone.",
      ],
      "sub_title_mr": [
        "आपणास आपला मोबाइल दुरुस्ती / देखभालीसाठी पाठवायचा असल्यास पुढील गोष्टी करा",
        "ब्राउझिंग हिस्टरी पूर्णपणे हटवा",
        "मेमरीमध्ये संचयित कॅशे आणि तात्पुरत्या फाइल्स साफ करा कारण त्यामध्ये आपले खाते क्रमांक आणि इतर संवेदनशील माहिती असू शकते",
        "आपल्या बँकेशी संपर्क साधून आपले मोबाइल बँकिंग अनुप्रयोग ब्लॉक करा. आपण मोबाइल परत घेता तेव्हा आपण त्यांना अनब्लॉक करू शकता.",
        "आपल्या मोबाइल फोनवर डेबिट / क्रेडिट कार्ड नंबर, सीव्हीव्ही नंबर किंवा पिन यासारख्या गोपनीय माहिती जतन करू नका",
      ],
    }
  ];

  var faqs = [
    {
      "title": "What is the Softcore Mobile Banking App?",
      "title_mr": "सॉफ्टकोर मोबाइल बँकिंग अॅप काय आहे?",
      "sub_title": [
        "The Softcore Mobile Banking App combines the benefits of Internet banking with the power of Android phones providing quick access to account information.\n" + "The Softcore Mobile Banking App allows you to easily transfer money between accounts, check your account balances, view transactions, account staements, Loan requests, cheque book requests, all types of transfers,recharges, Interest certificates and deposits slips."
      ],
      "sub_title_mr": [
        "सॉफ्टकोर मोबाइल बँकिंग अॅप आपल्याला बँकिंग विषयी सुविधा आपल्या अँड्रॉइड मोबाईल वर उपलब्ध करून देते. सॉफ्टकोर मोबाइल बँकिंग अॅप आपल्याला खात्यांमधील पैसे सहजतेने हस्तांतरित करण्यास सक्शन आहे तसेच आपले खाते शिल्लक तपासण्याची परवानगी देतो त्याचप्रमाणे व्यवहार पाहता येतात, खात्याचा हिशोब, कर्जाच्या विनंत्या, चेक बुक विनंत्या, सर्व प्रकारचे हस्तांतरण, रिचार्ज, व्याज प्रमाणपत्रे आणि ठेवी स्लिप इत्यादी सेवा उपलब्ध करून देते."
      ]
    },
    {
      "title": "What is required to use the Softcore Mobile Banking App?",
      "title_mr": "सॉफ्टकोर मोबाइल बँकिंग अॅप वापरण्यासाठी काय आवश्यक आहे?",
      "sub_title": ["An Online ID and Password from your Bank."],
      "sub_title_mr": ["बँकेने दिलेला युजर आयडी आणि पासवर्ड."]
    },
    {
      "title": "How do I get started using The Softcore Mobile Banking App?",
      "title_mr": "मी सॉफ्टकोर मोबाइल बँकिंग अॅप वापरणे कसे सुरू करू?",
      "sub_title": [
        "Once you have downloaded the app to your mobile device, you are ready to begin. Using your Mobile Banking User Id and Password, you can automatically begin managing your finances. Visit your bank to get Login User Id and Password."
      ],
      "sub_title_mr": [
        "एकदा आपण आपल्या मोबाइल डिव्हाइसवर अॅप डाउनलोड केल्यानंतर आपण, मोबाईल बँकिंग वापर सुरू करण्यास तयार आहात. आपला मोबाइल बँकिंग युजर  आयडी आणि पासवर्ड वापरुन आपण आपले व्यवहार करण्यास आरंभ करू शकता. लॉगिन युजर आयडी आणि पासवर्ड मिळविण्यासाठी आपल्या बँकेस भेट द्या."
      ]
    },
    {
      "title": "Is the Softcore Mobile Banking App safe?",
      "title_mr": "सॉफ्टकोर मोबाइल बँकिंग अॅप सुरक्षित आहे का?",
      "sub_title": [
        "Yes, the Softcore Mobile Banking App is safe and secure. It delivers the highest level of security with multiple layers of authentication including PIN. This ensures each login is unique and your information is fully protected. The Mobile Banking App travels in encrypted packets of data. 128-bit encryption protects data from being monitored during transmission across the Internet. The session ends when you close your app and times out if you forget."
      ],
      "sub_title_mr": [
        "होय, सॉफ्टकोर मोबाइल बँकिंग अॅप सुरक्षित आहे. हे पिनसह प्रमाणीकरणाच्या अनेक सुरक्षा निकषांचे पालन करते. हे सुनिश्चित करते की प्रत्येक लॉगिन अद्वितीय आहे आणि आपली माहिती पूर्णपणे संरक्षित आहे. मोबाइल बँकिंग अॅप डेटाच्या एन्क्रिप्टेड पॅकेटमध्ये प्रवास करतो. 128-बिट एन्क्रिप्शन संपूर्ण इंटरनेटवर ट्रान्समिशन दरम्यान डेटाचे परीक्षण करण्यापासून संरक्षण करते. आपण आपला अॅप बंद करता तेव्हा सत्र संपेल आणि आपण विसरल्यास वेळ संपेल."
      ]
    },
    {
      "title": "What are the requirements for Softcore Mobile banking PIN?",
      "title_mr": "सॉफ्टकोर मोबाइल बँकिंग पिनसाठी कोणत्या गोष्टी आवश्यक आहेत?",
      "sub_title": [
        "The mobile banking PIN must be 4-digits. For security reasons, the PIN cannot be comprised of all the same digits (1111) or sequential digits (1234, 4321)."
      ],
      "sub_title_mr": [
        "मोबाइल बँकिंग पिन 4-अंकांचा असणे आवश्यक आहे. सुरक्षिततेसाठी, सर्व समान अंक (1111) किंवा अनुक्रमांक (1234, 4321) सह पिन सेट करू नये."
      ]
    },
    {
      "title":
      "What types of accounts can I access with Softcore Mobile Banking?",
      "title_mr":
      "सॉफ्टकोर मोबाइल बँकिंगद्वारे मी कोणत्या प्रकारचे खाते पाहू शकतो?",
      "sub_title": [
        "Softcore Mobile Banking will provide access to the same accounts that are viewable through Online Banking, including current, savings,FD’s,CD’s and loans."
      ],
      "sub_title_mr": [
        "सॉफ्टकोर मोबाईल बँकिंग चालू खाती, बचत, एफडी, सीडी आणि कर्जासह ऑनलाईन बँकिंगद्वारे पाहण्यायोग्य असलेल्या खात्यांमध्ये प्रवेश प्रदान करेल."
      ]
    },
    {
      "title": "Is Bill Payments available through Softcore Mobile Banking?",
      "title_mr": "सॉफ्टकोर मोबाइल बँकिंगद्वारे बिल पेमेंट्स उपलब्ध आहेत का?",
      "sub_title": [
        "Yes,Bill Payment is available through Softcore Mobile Banking."
      ],
      "sub_title_mr": [
        "होय, सॉफ्टकोअर मोबाइल बँकिंगद्वारे बिल पेमेंट उपलब्ध आहे."
      ]
    },
    {
      "title": "How do I know that my funds transfer was successful?",
      "title_mr": "माझे निधी हस्तांतरण यशस्वी झाले हे मला कसे कळेल?",
      "sub_title": [
        "Each time you make a transfer a confirmation SMS text/email message will \n" +
            "be sent to your mobile device."
      ],
      "sub_title_mr": [
        "्रत्येक वेळी आपण हस्तांतरण करता तेव्हा आपल्या मोबाइल डिव्हाइसवर एक पुष्टीकरण एसएमएस मजकूर / ईमेल संदेश पाठविला जाईल."
      ]
    },
    {
      "title": "Will account information reside on my phone?",
      "title_mr": "खाते माहिती माझ्या फोनवर राहील का?",
      "sub_title": [
        "Just like Online Access, all account data resides at the bank.\n" +
            "All data placed into local storage on cell phone is first encrypted. \n" +"This ensures that if the phone is lost or stolen,the data stored locally for the Mobile Banking application is unreadable."
      ],
      "sub_title_mr": [
        "ऑनलाईन प्रवेशाप्रमाणेच सर्व खाते डेटा बँकेत असतो. सेल फोनवर स्थानिक संग्रहात ठेवलेला सर्व डेटा प्रथम कूटबद्ध केला आहे. हे सुनिश्चित करते की जर फोन हरवला किंवा चोरीला गेला असेल तर मोबाइल बँकिंग अनुप्रयोगासाठी स्थानिकपणे संग्रहित डेटा वाचनीय नाही."
      ]
    },
    {
      "title": "Is operator available 24x7?",
      "title_mr": "सेवा 24x7 उपलब्ध आहे का?",
      "sub_title": ["Yes, the operator is available round the clock."],
      "sub_title_mr": ["होय, ही सेवा चोवीस तास उपलब्ध आहे."]
    },
    {
      "title":
      "How do I know that no unauthorized payments are made using Softcore Mobile Banking?",
      "title_mr":
      "सॉफ्टकोर मोबाइल बँकिंग वापरुन कोणतीही अनधिकृत देयके दिली जात नाहीत हे मला कसे कळेल?",
      "sub_title": [
        "With Softcore Mobile Banking you initiate and authorize each and every payment that is made from your account. If you share your phone with another person, make sure you exit from the Softcore Mobile Banking application on your mobile phone. Also do NOT share your User ID / PIN with anyone."
      ],
      "sub_title_mr": [
        "सॉफ्टकोर मोबाइल बँकिंगद्वारे आपण आपल्या खात्यातून बनविलेले प्रत्येक देयक आरंभ आणि अधिकृत करता. आपण आपला फोन दुसर्या व्यक्तीला देऊ केल्यास आपण आपल्या मोबाइल फोनवरील सॉफ्टकोर मोबाइल बँकिंग अनुप्रयोगातून बाहेर पडल्याचे सुनिश्चित करा. आपला यूझर आयडी / पिन कोणालाही सांगू नका."
      ]
    },
    {
      "title":
      "What happens if my phone gets hung when I am in the midest of a transaction?",
      "title_mr":
      "मी व्यवहाराच्या मध्यभागी असताना माझा फोन हँग झाल्यास काय होईल?",
      "sub_title": [
        "Switch off the mobile and switch it on. Login to the application using your User ID."
      ],
      "sub_title_mr": [
        "मोबाइल बंद करा आणि तो चालू करा. आपला यूजर आयडी वापरुन अँपमध्ये लॉग इन करा."
      ]
    },
    {
      "title":
      "What happens if my phone gets switched off during a transaction?",
      "title_mr": "व्यवहाराच्या दरम्यान माझा फोन बंद झाला तर काय होते?",
      "sub_title": [
        "Switch on the phone and start using the application from the beginning."
      ],
      "sub_title_mr": [
        "फोन चालू करा आणि सुरुवातीपासूनच अॅप्लिकेशनचा वापर सुरू करा."
      ]
    },
    {
      "title":
      "I can't to find the Softcore Mobile Banking Banking Application im my mobile?",
      "title_mr":
      "मी माझ्या मोबाइलवर सॉफ्टकोर मोबाइल बँकिंग बँकिंग अनुप्रयोग शोधू शकत नाही?",
      "sub_title": [
        "Please go to MENU section and open Application folder .You will find an icon named Softcore Mobile Banking which contains Softcore Mobile Banking Application."
      ],
      "sub_title_mr": [
        "कृपया मेनू विभागात जा आणि अॅप्लिकेशन फोल्डर उघडा. आपल्याला सॉफ्टकोर मोबाइल बँकिंग नावाचे एक चिन्ह मिळेल ज्यामध्ये सॉफ्टकोर मोबाइल बँकिंग अँप आहे."
      ]
    },
    {
      "title": "Is app services available in other languages?",
      "title_mr": "अॅप सेवा इतर भाषांमध्ये उपलब्ध आहेत का?",
      "sub_title": ["Yes, the services are available in English and Marathi."],
      "sub_title_mr": ["होय, सेवा इंग्रजी आणि मराठीमध्ये उपलब्ध आहेत."]
    },
    {
      "title": "Can I view the transactions relating to my account?",
      "title_mr": "मी माझ्या खात्याशी संबंधित व्यवहार पाहू शकतो का?",
      "sub_title": [
        "Yes, Mini statement allows you to view a summary of your last 5 transactions."
      ],
      "sub_title_mr": [
        "होय, मिनी स्टेटमेंट आपल्याला आपल्या शेवटच्या 5 व्यवहारांचा सारांश पाहण्याची परवानगी देते."
      ]
    },
    {
      "title": "How can I add new beneficiary?",
      "title_mr": "मी नवीन लाभार्थी कसा जोडू शकतो?",
      "sub_title": [
        "On the transaction form, you will see “Manage”, click on that then press “+” icon and fill all information of beneficiary and click on “Continue” button. Confirm entered information and enter the OTP recieved on your registered mobile no."
      ],
      "sub_title_mr": [
        "्रान्झॅक्शन फॉर्मवर तुम्हाला “मॅनेज” दिसेल, त्यावर क्लिक करा आणि नंतर “+” आयकॉन दाबा आणि लाभार्थीची सर्व माहिती भरा आणि “सुरू ठेवा” बटणावर क्लिक करा. प्रविष्ट केलेल्या माहितीची पुष्टी करा आणि आपल्या नोंदणीकृत मोबाईल नंबरवर प्राप्त केलेला ओटीपी प्रविष्ट करा."
      ]
    },
    {
      "title": "How can I delete a beneficiary?",
      "title_mr": "मी लाभार्थीला कसे हटवू?",
      "sub_title": [
        "Open beneficiaries list, long press the beneficiary name , you will see the confirmation pop-up, click on “Yes”."
      ],
      "sub_title_mr": [
        "लाभार्थ्यांची यादी उघडा, लाभार्थीचे नाव दाबा, तुम्हाला पुष्टीकरण पॉप-अप दिसेल, “होय” वर क्लिक करा."
      ]
    },
    {
      "title": "How can I search an IFSC code?",
      "title_mr": "मी आयएफएससी कोड कसा शोधू शकतो?",
      "sub_title": [
        "Just click on “Search IFSC code”, enter Bank Name and branch name or IFSC code you known, and click on “Search”, you will get IFSC code along with bank and branch."
      ],
      "sub_title_mr": [
        "आयएफएससी कोड शोधा” वर क्लिक करा, बँकेचे नाव व शाखांचे नाव किंवा तुम्हाला ज्ञात आयएफएससी कोड प्रविष्ट करा आणि “शोध” वर क्लिक करा, तुम्हाला बँक व शाखांसह आयएफएससी कोड मिळेल."
      ]
    }
  ];

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    setState(() {
      if (widget.menuFor == 'Tips') {
        data.clear();
        data = tips;
      } else {
        data.clear();
        data = faqs;
      }
      print("Data" + data.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Container(
        color: Colors.grey[100],
        child: SafeArea(
          child: Scaffold(
            key: _scafoldKey,
            backgroundColor:Theme.of(context).backgroundColor,
            body: Column(
              children: [
                SizedBox(height: 10),
                CustomAppbar(
                  onIconPressed: (){
                    setState(() {
                      isMarathi = !isMarathi;
                    });
                  },
                  backButtonVisibility: true,
                  onBackPressed: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WelcomePage(
                        ),
                        // builder: (_) => SubjectsPage(),
                      ),
                    );
                  },
                  icon: Icons.language_rounded,
                  caption: widget.menuFor == 'Tips'?'Security Tips':' FAQ',
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Icon(
                                Icons.ac_unit_rounded,
                                color :Theme.of(context).primaryColorDark
                            ),
                            collapsedBackgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                            backgroundColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                            title: new Text(
                              isMarathi ? data[i]['title'] : data[i]['title_mr'],
                              style:  Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            children: <Widget>[
                              new Column(
                                children: _buildExpandableContent(
                                  isMarathi
                                      ? data[i]['sub_title']
                                      : data[i]['sub_title_mr'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildExpandableContent(var tips) {
    List<Widget> columnContent = [];

    for (var content in tips)
      columnContent.add(
        new ListTile(
          title: new Text(
            content,
            textAlign: TextAlign.justify,
            style:
            Theme.of(context).textTheme.bodyText2.copyWith(
              // color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
         // leading: new Icon(Icons.ac_unit),
        ),
      );
    return columnContent;
  }
}

