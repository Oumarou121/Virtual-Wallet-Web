import 'package:flutter/material.dart';
import 'package:virtual_wallet_web/common/loading.dart';
import 'package:virtual_wallet_web/screens/security/CodePinWeb1.dart';
import 'package:virtual_wallet_web/sevices/authentication.dart';
import 'package:virtual_wallet_web/utils/utils.dart';
import 'package:virtual_wallet_web/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.userData});
  final userData;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  String error = '';

  Widget _inputEmail({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        decoration: InputDecoration(
            prefixIconColor: SwicthColor(userData: userData),
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email)),
        validator: (val) => uValidator(
          value: val,
          isRequred: true,
          isEmail: true,
        ),
      ),
    );
  }

  Widget _inputPassword({required userData}) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: Stack(
        children: <Widget>[
          Container(
            child: TextFormField(
                controller: _password,
                obscureText: _obscureText,
                decoration: InputDecoration(
                    prefixIconColor: SwicthColor(userData: userData),
                    labelText: SwicthLangues(
                        userData: userData, fr: 'Mot de passe', en: 'Password'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                validator: (val) => uValidator(
                      value: val,
                      isRequred: true,
                      minLength: 6,
                    )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: SwicthColor(userData: userData),
                ),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputConfirm(){
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            setState(() => _isLoading = true);

            dynamic result = await _auth.signIn(
                email: _email,
                password: _password.text);
            // await Future.delayed(Duration(seconds: 2));
            // print(result);
            if (result != null) {
              if (mounted)
                setState(() {
                  _isLoading = false;
                });
              if (result ==
                  '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                setState(() {
                  _isLoading = false;
                  error = SwicthLangues(
                      userData: widget.userData,
                      fr: 'Veillez vérifier votre connexion internet',
                      en: 'Please check your internet connection');
                });
              } else {
                if (result ==
                    '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                  setState(() {
                    _isLoading = false;
                    error = SwicthLangues(
                        userData: widget.userData,
                        fr: 'Aucun compte emregistre sur cet email',
                        en: 'No account registered on this email');
                  });
                } else {
                  if (result ==
                      '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
                    setState(() {
                      _isLoading = false;
                      error = SwicthLangues(
                          userData: widget.userData,
                          fr: 'Mot de passe incorrect',
                          en: 'Incorrect password');
                    });
                  } else {
                    if (mounted) {
                      if (result == 'false') {
                        setState(() {
                          _isLoading = false;
                          error = SwicthLangues(
                              userData: widget.userData,
                              fr: 'Veillez vérifier votre connexion internet',
                              en: 'Please check your internet connection');
                        });
                      } else {
                        setState(
                                () => _isLoading = false);
                        wPushReplaceTo1(
                            context, CodePinWeb1());
                      }

                    }
                  }
                }
              }
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              SwicthColor(userData: widget.userData)),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: Text(SwicthLangues(
            userData: widget.userData,
            fr: 'Se Connceter',
            en: 'Login')),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    SwicthLangues(
                        userData: widget.userData,
                        fr: "Se Connecter",
                        en: "Login"),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,

                ),
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.contain,
                          image: const AssetImage("images/img_login.png"),
                        ),
                        SizedBox(height: 4),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 24),
                            _inputEmail(userData: widget.userData),
                            SizedBox(height: 30),
                            _inputPassword(userData: widget.userData),
                             SizedBox(height: 30),
                            _inputConfirm(),
                            SizedBox(height: 14),
                            Center(
                              child: Text(error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )),
              ));
  }
}
