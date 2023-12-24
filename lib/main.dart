
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_wallet_web/firebase_options.dart';
import 'package:virtual_wallet_web/sevices/authentication.dart';
import 'package:virtual_wallet_web/splashWeb.dart';

import 'models/user.dart';


//main() async {
  //WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp(
      //  options: FirebaseOptions(
        //    apiKey: "AIzaSyCq8aO67UaO79T3kmP-8te7DQmOEclejuc",
          //  authDomain: "my-virtual-wallet-5f4d7.firebaseapp.com",
            //projectId: "my-virtual-wallet-5f4d7",
            //storageBucket: "my-virtual-wallet-5f4d7.appspot.com",
            //messagingSenderId: "793314480218",
            //appId: "1:793314480218:web:1412f4b9496da62f8c8863",
            //measurementId: "G-BLJBC7JGVW"));

  //runApp(MyApp());
//}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreenWrapperWeb() ,
      ),
    );
  }
}
