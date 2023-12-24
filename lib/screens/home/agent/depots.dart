import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_wallet_web/screens/home/SwitchHomeWeb.dart';
import 'package:virtual_wallet_web/screens/home/agent/depotsConfirm.dart';
import 'package:virtual_wallet_web/utils/utils.dart';
import 'package:virtual_wallet_web/widgets/widgets.dart';

// ignore: must_be_immutable
class depots extends StatefulWidget {
  depots(
      {super.key,
        required this.userData});

  var userData;

  @override
  State<depots> createState() => _depotsState();
}

class _depotsState extends State<depots> {
  TextEditingController _montant = TextEditingController();
  String error = '';
  String PhoneNumber = '';
String IdR = '';
  List<Country> countries = [
    Country(
      name: "Niger",
      nameTranslations: {
        "sk": "Niger",
        "se": "Niger",
        "pl": "Niger",
        "no": "Niger",
        "ja": "ニジェール",
        "it": "Niger",
        "zh": "尼日尔",
        "nl": "Niger",
        "de": "Niger",
        "fr": "Niger",
        "es": "Níger",
        "en": "Niger",
        "pt_BR": "Níger",
        "sr-Cyrl": "Нигер",
        "sr-Latn": "Niger",
        "zh_TW": "尼日爾",
        "tr": "Nijer",
        "ro": "Niger",
        "ar": "النيجر",
        "fa": "نیجر",
        "yue": "尼日爾"
      },
      flag: "🇳🇪",
      code: "NE",
      dialCode: "227",
      minLength: 8,
      maxLength: 8,
    ),
  ];

  Widget _inputAmount() {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _montant,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData:widget. userData),
            hintText: SwicthLangues(
                userData:widget. userData,
                fr: 'Montant',
                en: 'Amount'),
           // helperText: SwicthLangues(
             //   userData: userData,
               // fr: 'Entert son nom complet',
               // en: 'Entert Full Name'),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.money_outlined)),
        validator: (val) => uValidator(
          value: val,
          isAmount: true,
          isRequred: true,
          minLength: 3,
        ),
      ),
    );
  }

  Widget _inputConfirm() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 64,
      child: ElevatedButton(
          onPressed: () async {
            var collection = FirebaseFirestore.instance.collection("users");
            var num =
            await collection.where("phone", isEqualTo: PhoneNumber).get();
            print(num.size);
            if (PhoneNumber.isEmpty) {
              setState(() {
                error = SwicthLangues(
                    userData:widget. userData,
                    fr: 'Veillez saisir le numéro du receveur',
                    en: 'Please enter the receiver number');
              });
            } else {
              if (num.size == 1) {
                //dépots actions
                await collection
                    .where("phone", isEqualTo: PhoneNumber)
                    .get()
                    .then((snapshot) => snapshot.docs.forEach((document) {
                  setState(() {
                    IdR = document.reference.id;
                  });
                }));
                wPushReplaceTo2(context, depotsConfirm(IdR: IdR, Montant: int.parse(_montant.text),));
              } else {
                setState(() {
                  error = SwicthLangues(
                      userData:widget. userData,
                      fr: 'Ce numéro ne possède pas un compte',
                      en: "This number hasn't an account");
                });
              }
            }
          },
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(SwicthColor(userData:widget. userData)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(SwicthLangues(
              userData:widget. userData, fr: 'Confirmer', en: 'Confirm'))),
    );
  }

  Widget _top() {
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
                  SwicthLangues(userData:widget. userData, fr: 'Dépôts', en: 'Depots'),
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
                onPressed: () {
                 wPushReplaceTo2(context, BankAppWeb());
                }))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
                return Scaffold(
                  body: SafeArea(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Column(
                            children: [
                              _top(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height / 3),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: IntlPhoneField(
                                  countries: countries,
                                  onChanged: (value) {
                                    setState(() {
                                      PhoneNumber = value.completeNumber;
                                    });
                                    print(value.completeNumber);
                                  },
                                  initialCountryCode: 'NE',
                                  decoration: InputDecoration(
                                    labelText: SwicthLangues(
                                        userData: widget.userData,
                                        fr: 'Numéro du bénéficien',
                                        en: 'Number of beneficiary'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            _inputAmount(),
                              const SizedBox(height: 30),
                              _inputConfirm(
                                  ),
                              const SizedBox(height: 10),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      )),
                );
              }
            }


