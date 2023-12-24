import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_web/common/loading.dart';
import 'package:virtual_wallet_web/models/user.dart';
import 'package:virtual_wallet_web/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_web/sevices/database.dart';
import 'package:virtual_wallet_web/utils/utils.dart';
import 'package:virtual_wallet_web/widgets/widgets.dart';

class AgenceConfirm extends StatefulWidget {
  AgenceConfirm({super.key, required this.userData,required this.PhoneNumber});
  final  userData;
  final String PhoneNumber;
  @override
  State<AgenceConfirm> createState() => _AgenceConfirmState();
}

class _AgenceConfirmState extends State<AgenceConfirm> {
  // final AuthenticationService _auth = AuthenticationService();
  String Uid = 'hGaqMsHWmXUhetexvnuqG3Ft01B3';
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String text = "Historique vide";
  bool onClick = true;
  bool _isLoading = false;
  var time = DateTime.now();
  var data = [
    '',
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  _incrementCounter({required collection}) async {
    List<Map<String, dynamic>> tempsList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      tempsList.add(element.data());
      if (mounted)
        return setState(() {
          items = tempsList;
          isLoaded = true;
        });
    });
  }
  var day;

  void _day() {
    if (time.day < 10) {
      setState(() {
        day = '0${time.day}';
      });
    } else {
      day = time.day;
    }
  }

  var mois;

  void _mois() {
    if (time.month < 10) {
      setState(() {
        mois = '0${time.month}';
      });
    } else {
      mois = time.month;
    }
  }

  var hours;

  void _hours() {
    if (time.hour < 10) {
      setState(() {
        hours = '0${time.hour}';
      });
    } else {
      hours = time.hour;
    }
  }

  var minutes;

  void _minutes() {
    if (time.minute < 10) {
      setState(() {
        minutes = '0${time.minute}';
      });
    } else {
      minutes = time.minute;
    }
  }

  var seconds;

  void _seconds() {
    if (time.second < 10) {
      setState(() {
        seconds = '0${time.second}';
      });
    } else {
      seconds = time.second;
    }
  }

  void _destory({required index}) async {
    await FirebaseFirestore.instance
        .collection(Uid)
        .doc(items[index]["order"])
        .delete();
    var collection = FirebaseFirestore.instance
        .collection(Uid)
        .where("PhoneR", isEqualTo:widget. PhoneNumber);
    await _incrementCounter(collection: collection);
    onClick = true;
  }

  void Succes({required items, required int index,required items1}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return WSucces(items: items, index: index,items1: items1);
        });
  }

  Widget WSucces({required items,required items1 ,required int index}) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle),
              ),
              _imputNameS(
                  PlayerNameS
                      : items['NameS'], userData: widget.userData),
              const SizedBox(height: 10),
              _imputNumberS(
                  PlayerNumberS
                      : items['PhoneS'], userData: widget.userData),
              const SizedBox(height: 10),
              _imputNameR(
                  PlayerNameR
                      : items['NameR'], userData: widget.userData),
              const SizedBox(height: 10),
              _imputNumberR(
                  PlayerNumberR
                      : items['PhoneR'], userData: widget.userData),
              const SizedBox(height: 10),
              _imputAmount(
                  PlayerAmount: items['Solde'], userData: widget.userData),
              const SizedBox(height: 20),
              _inputConfirm(index: index, items1: items1,items: items)
            ],
          )
        ],
      ),
    );
  }

  Widget _imputNameS({required PlayerNameS, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: "Nom de l'envoyeur :  $PlayerNameS",
                en: 'Resubscription number :  $PlayerNameS'),
            style: TextStyle(fontSize: 24, letterSpacing: 5),
          )),
    );
  }

  Widget _imputNumberS({required PlayerNumberS, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: "Numéro de l'envoyeur :  $PlayerNumberS",
                en: 'Resubscription number :  $PlayerNumberS'),
            style: TextStyle(fontSize: 24, letterSpacing: 5),
          )),
    );
  }
  Widget _imputNameR({required PlayerNameR, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: "Nom du bénéficien :  $PlayerNameR",
                en: 'Nom du bénéficien :  $PlayerNameR'),
            style: TextStyle(fontSize: 24, letterSpacing: 5),
          )),
    );
  }

  Widget _imputNumberR({required PlayerNumberR, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: "Numéro du bénéficien :  $PlayerNumberR",
                en: 'Nom du bénéficien :  $PlayerNumberR'),
            style: TextStyle(fontSize: 24, letterSpacing: 5),
          )),
    );
  }





  Widget _imputAmount({required PlayerAmount, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
        SwicthLangues(
            userData: userData,
            fr: 'Montant :  $PlayerAmount',
            en: 'Amount :  $PlayerAmount'),
        style: TextStyle(fontSize: 24, letterSpacing: 5),
      )),
    );
  }

  Widget _inputConfirm({required int index, required items1,required items}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            if (onClick = true) {
              setState(() {
                onClick = false;
                _isLoading = true;
              });
              var month = data[time.month];
              _day();
              _mois();
              _hours();
              _minutes();
              _seconds();
              var collection = FirebaseFirestore.instance
                  .collection('Confirm $Uid');
              await collection
                  .doc('${time.year}$mois$day$hours$minutes$seconds')
                  .set({
                "PhoneR": items['PhoneR'],
                "NameR": items['NameR'],
                "PhoneS": items['PhoneS'],
                "NameS": items['NameR'],
                "Date":
                ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
                "Solde": items['Solde'],
                "order": '${time.year}$mois$day$hours$minutes$seconds',
              });
              Navigator.pop(context);
              if (items1.length == 1) {
                _destory(index: index);
                isLoaded = true;
                text = "No Data";
                setState(() {});
                wPushReplaceTo1(context, BankAppWeb());
              } else {
                _destory(index: index);
                Navigator.of(context).pop();
              }
              setState(() {
                _isLoading = false;
              });
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                SwicthColor(userData: widget.userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(
              style: TextStyle(fontSize: 24),
              SwicthLangues(userData: widget.userData, fr: 'Confirmer', en: 'Confirm')),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .collection(Uid)
        .where("PhoneR", isEqualTo:widget. PhoneNumber);
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return StreamProvider<AppUserData?>.value(
        value: database.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: database.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userData = snapshot.data;
                if (userData == null) return Loading();
                return _isLoading ? Loading() : Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        wPushReplaceTo2(context, BankAppWeb());
                      },
                      icon: Icon(
                        Iconsax.back_square,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      'Agence',
                      style: TextStyle(
                          fontSize: 32, letterSpacing: 5, color: Colors.black),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  extendBodyBehindAppBar: true,
                  body: FutureBuilder(
                      future: _incrementCounter(collection: collection),
                      builder: (context, snapshot) {
                        return Center(
                            child: isLoaded
                                ? Center(
                                    child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return _HistoryItems(index: index);
                                    },
                                  ))
                                : Text(
                                    style: TextStyle(
                                        color:
                                            DefaultSelectionStyle.defaultColor),
                                    text));
                      }),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: SwicthColor(userData: widget.userData),
                    onPressed: () async {
                      _incrementCounter(collection: collection);
                    },
                    tooltip: 'increment',
                    child: const Icon(
                      Iconsax.refresh_circle,
                      size: 30,
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            }));
  }

  Widget _HistoryItems({required int index}) {
    return GestureDetector(
      onTap: () {
        Succes(items: items[index], index: index,items1: items);
      },
      child: Padding(
          padding: const EdgeInsets.all(6),
          child: Card(
            shape: RoundedRectangleBorder(
                // side: const BorderSide(width: 0),
                borderRadius: BorderRadius.circular(1200)),
            elevation: 6,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 0),
                  borderRadius: BorderRadius.circular(1200)),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Iconsax.receipt),
              ),
              title: Text(items[index]["NameR"],
                  style: GoogleFonts.poppins(
                      letterSpacing: 2.5,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
              subtitle: Text(items[index]["Date"],
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              trailing: Text("${items[index]["Solde"].toString()} ECO",
                  style: GoogleFonts.poppins(
                      letterSpacing: 2.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
            ),
          )),
    );
  }
}
