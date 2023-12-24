import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_web/models/user.dart';
import 'package:virtual_wallet_web/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_web/utils/utils.dart';
import 'package:virtual_wallet_web/widgets/widgets.dart';

class AchatsUid extends StatefulWidget {
  AchatsUid({super.key,required this.ID, required this.userData});
 final String ID;
 final AppUserData userData;
  @override
  State<AchatsUid> createState() => _AchatsUidState();
}

class _AchatsUidState extends State<AchatsUid> {
  String qrCode = '';
  String error = '';
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;

  // ignore: unused_element
  _incrementCounter({required collection}) async {
    List<Map<String, dynamic>> tempsList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      tempsList.add(element.data());
      setState(() {
        items = tempsList;
        isLoaded = true;
      });
    });
  }

  Widget _SendID({required Uid}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: Column(
          children: [
            Text('Mon Uid',style:TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            _inputUid(Uid: Uid),

          ],
        ),
      ),
    );
  }



  Widget _inputUid({required Uid}) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: MediaQuery.of(context).size.height / 3,
     child:  BarcodeWidget(
        barcode: Barcode.qrCode(),
        color: Colors.black,
        data: Uid,
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height / 3,
      ),
    );
  }


  // ignore: unused_element
  Widget _top({required userData}) {
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
                  SwicthLangues(
                      userData: userData, fr: 'Achats Uid', en: 'Achats Uid'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
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
                onPressed: () => wPushReplaceTo2(context, BankAppWeb())))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Achats Uid',
          style: TextStyle(
              fontSize: 32, letterSpacing: 5, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                //  _top(userData: widget.userData),
                   SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  _SendID(Uid: widget.ID),
                  const SizedBox(height: 10),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
