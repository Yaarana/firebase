import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newfb/utils/routes.dart';

class phoneverification extends StatefulWidget {
  const phoneverification({super.key});

  static String verify = "";

  @override
  State<phoneverification> createState() => _phoneverificationState();
}

class _phoneverificationState extends State<phoneverification> {
  final _formkey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  var phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF17915e), Color(0xFF453185)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 190),
                  child: Text(
                    'Log in with Phone',
                    style: TextStyle(color: Colors.white, fontSize: 27),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 210,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 270,
                        child: TextFormField(
                          onChanged: (value) {
                            phone = value;
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Enter your number',
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(1.0),
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              suffixIcon: Icon(Icons.phone_android_outlined),
                              suffixIconColor: Colors.white),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 10) {
                              return 'Please enter a valid Number';
                            }

                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.withOpacity(0.2))),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91 ${phone}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  phoneverification.verify = verificationId;
                                  Navigator.pushNamed(context, MyRoutes.otp);
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            }
                          },
                          child: Text('Send OTP'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MyRoutes.loginpage);
                            },
                            child: Text(
                              'Login with Email, Password',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6)),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
