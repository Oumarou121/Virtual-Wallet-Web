import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_web/common/loading.dart';
import 'package:virtual_wallet_web/models/user.dart';
import 'package:virtual_wallet_web/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_web/screens/home/agent/depots.dart';
import 'package:virtual_wallet_web/sevices/database.dart';
import 'package:virtual_wallet_web/utils/utils.dart';
import 'package:virtual_wallet_web/widgets/widgets.dart';

class depotsConfirm extends StatefulWidget {
  depotsConfirm(
      {super.key,
     required this.IdR,required this.Montant});
  final String IdR;
 final int Montant;
  @override
  State<depotsConfirm> createState() => _depotsConfirmState();
}

class _depotsConfirmState extends State<depotsConfirm> {
  String error = '';
  var time = DateTime.now();
  bool _isLoading = false;




  Future<void> SuccesAction(
      {
        required int Factures,
        required databaseS,
        required databaseR,
        required AppUserData userDataS,
        required AppUserData userDataR,
        required MyUid,
        required collectionS,
        required collectionR}) async {
    var month = data[time.month];
    _day();
    _mois();
    _hours();
    _minutes();
    _seconds();

    await databaseS.saveUser(
        userDataS.name,
        userDataS.waterCounter - widget.Montant,
        userDataS.password,
        userDataS.passwordSign,
        userDataS.playerUid,
        userDataS.phone,
        userDataS.token,
        userDataS.ImageUrl,
        userDataS.DBiometrique,
        userDataS.CBiometrique,
        userDataS.autoBrightness,
        userDataS.isDark,
        userDataS.primaryColor,
        userDataS.langues);
    await databaseR.saveUser(
        userDataR.name,
        userDataR.waterCounter + widget.Montant,
        userDataR.password,
        userDataR.passwordSign,
        userDataR.playerUid,
        userDataR.phone,
        userDataR.token,
        userDataR.ImageUrl,
        userDataR.DBiometrique,
        userDataR.CBiometrique,
        userDataR.autoBrightness,
        userDataR.isDark,
        userDataR.primaryColor,
        userDataR.langues);
    await collectionS.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": 'images/profile.png',
      "Phone": userDataR.phone,
      "Name": userDataR.name,
      "Date":
      ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": widget.Montant,
      "order": '${time.year}$mois$day$hours$minutes$seconds'
    });
    await collectionR.doc('${time.year}$mois$day$hours$minutes$seconds').set({
      "Image": userDataS.ImageUrl.isEmpty ? userDataS.ImageUrl : userDataS.name[0],
      "Phone": userDataS.phone,
      "Name": userDataS.name,
      "Date":
      ' $day $month ${time.year}      à      ${time.hour}h : ${time.minute}mn ',
      "Solde": widget.Montant,
      "order": '${time.year}$mois$day$hours$minutes$seconds',
      "uid": MyUid,
    });

    Succes(userData: userDataS);
  }

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

  bool onClick = true;

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

  Widget _inputConfirm(
      {required AppUserData userDataR,
        required databaseR,
        required AppUserData userDataS,
        required databaseS,
        required MyUid,
        required YourUid}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (onClick = true) {
            setState(() {
              onClick = false;
              _isLoading = true;
            });

            var collectionS =
            FirebaseFirestore.instance.collection('Recharge $MyUid');
            var collectionR = FirebaseFirestore.instance.collection('Recharge $YourUid');
            if (widget.Montant <= userDataS.waterCounter) {


          SuccesAction(
                    Factures: widget.Montant,
                    databaseS: databaseS,
                    databaseR: databaseR,
                    userDataS: userDataS,
                    userDataR: userDataR,
                    MyUid: MyUid,
                    collectionS: collectionS,
                    collectionR: collectionR);

            } else {
              setState(() {
                _isLoading = false;
                error = SwicthLangues(
                    userData: userDataS,
                    fr: 'Votre Solde est insuffisant',
                    en: 'Your balance is insufficient');
              });
            }
          }
        },
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(SwicthColor(userData: userDataS)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: Text(
            SwicthLangues(userData: userDataS, fr: 'Confirmer', en: 'Confirm')),
      ),
    );
  }

  void Succes({required userData}) {
    setState(() {
      _isLoading = false;
    });
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return _Succes(userData: userData);
        });
  }

  Widget _Succes({required userData}) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.drag_handle),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade300),
                child: TextButton(
                    child: Text(
                        SwicthLangues(
                            userData: userData, fr: 'Succès', en: 'Success'),
                        style: TextStyle(fontSize: 32)),
                    onPressed: () =>
                        wPushReplaceTo1(context, BankAppWeb())),
              ))
        ],
      ),
    );
  }

  Widget _top({required userDataS}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '      ',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                Text(
                  'Dépôts',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(Iconsax.back_square, color: Colors.black),
              iconSize: 24,
              onPressed: () => wPushReplaceTo2(
                  context,
                  depots(userData: userDataS,)),
            ))
      ]),
    );
  }

  Widget _imputName({required PlayerName, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: 'Nom du bénéficien : $PlayerName',
                en: 'Name of beneficiary : $PlayerName'),
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Widget _imputNumber({required PlayerNumber, required userData}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade300),
      child: Center(
          child: Text(
            SwicthLangues(
                userData: userData,
                fr: 'Numéro du bénéficien : $PlayerNumber',
                en: 'Number of beneficiary : $PlayerNumber'),
            style: TextStyle(fontSize: 16),
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
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Widget _SendConfirm(
      {required PlayerName,
        required PlayerNumber,
        required PlayerAmount,
        required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            _imputName(PlayerName: PlayerName, userData: userData),
            const SizedBox(height: 10),
            _imputNumber(PlayerNumber: PlayerNumber, userData: userData),
            const SizedBox(height: 10),
            _imputAmount(PlayerAmount: PlayerAmount, userData: userData),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final databaseS = DatabaseService(user.uid);
    final databaseR = DatabaseService(widget.IdR);
    return StreamProvider<AppUserData?>.value(
        value: databaseR.user,
        initialData: null,
        child: StreamBuilder<AppUserData>(
            stream: databaseR.user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                AppUserData? userDataR = snapshot.data;
                if (userDataR == null) return Loading();
                return StreamProvider<AppUserData?>.value(
                    value: databaseS.user,
                    initialData: null,
                    child: StreamBuilder<AppUserData>(
                        stream: databaseS.user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            AppUserData? userDataS = snapshot.data;
                            if (userDataS == null) return Loading();
                            return Scaffold(
                              // backgroundColor: Colors.grey.shade100,
                              body: _isLoading
                                  ? Loading()
                                  : SafeArea(
                                  child: GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      child: Column(
                                        children: [
                                          _top(
                                              userDataS: userDataS),
                                          const SizedBox(height: 200),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                    style: TextStyle(
                                                        color:
                                                        DefaultSelectionStyle
                                                            .defaultColor),
                                                    SwicthLangues(
                                                        userData: userDataS,
                                                        fr: "Voulez-vous vraiment transfère",
                                                        en: "Do you really want to transfer")),
                                                SizedBox(height: 15),
                                                _SendConfirm(
                                                    PlayerName: userDataR.name,
                                                    PlayerNumber:userDataR.phone,
                                                    PlayerAmount:
                                                    widget.Montant,
                                                    userData: userDataS)
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          _inputConfirm(
                                              userDataR: userDataR,
                                              databaseR: databaseR,
                                              userDataS: userDataS,
                                              databaseS: databaseS,
                                              MyUid: user.uid,
                                          YourUid: widget.IdR),
                                          const SizedBox(height: 10),
                                          Text(
                                            error,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          } else {
                            return Loading();
                          }
                        }));
              } else {
                return Loading();
              }
            }));
  }
}
