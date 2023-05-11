import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newfb/phoneverificaton.dart';
import 'package:newfb/utils/routes.dart';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
var code;
final _fKey = GlobalKey<FormState>();

class _otpState extends State<otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _fKey,
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
                    'Enter your code',
                    style: TextStyle(color: Colors.white, fontSize: 27),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 150,
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
                            code = value;
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Enter code',
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(1.0),
                              ),
                              fillColor: Colors.white.withOpacity(0.2),
                              filled: true,
                              suffixIcon: Icon(Icons.phone_android_outlined),
                              suffixIconColor: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter OTP';
                            } else if (value != code) {
                              return 'Invalid OTP';
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
                            if (_fKey.currentState!.validate()) {
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: phoneverification.verify,
                                      smsCode: code);

                              // Sign the user in (or link) with the credential
                              await auth.signInWithCredential(credential);
                              Navigator.pushNamed(context, MyRoutes.homepage);
                            }
                          },
                          child: Text('Log In'),
                        ),
                      ),
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
