import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newfb/utils/routes.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _formkey = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF6117bd), Color(0xFF17915e)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 230,
                ),
                Container(
                  child: Text(
                    'Create New Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 65,
                  width: 268,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: Icon(Icons.email),
                        suffixIconColor: Colors.grey,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid Email';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 65,
                  width: 268,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextFormField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      onChanged: (value) {
                        pass = value;
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: Icon(Icons.password_sharp),
                        suffixIconColor: Colors.grey,
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        } else if (value.length < 6) {
                          return 'Atleast 6 character required';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0xFF010759), Color(0xFF0248B9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)))),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        final message = SnackBar(
                            content: Text(
                          'Form Submitted',
                        ));
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: pass,
                          );
                          Navigator.pushNamed(context, MyRoutes.homepage);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text(
                      'Register',
                    ),
                  ),
                  height: 50,
                  width: 250,
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.loginpage);
                  },
                  child: Text(
                    'Already have an account, CLick to Log in',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 110,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent),
                    ),
                    onPressed: () {
                      signInWithGoogle().then((value) =>
                          Navigator.pushNamed(context, MyRoutes.homepage));
                    },
                    label: Text('Google'),
                    icon: FaIcon(FontAwesomeIcons.google),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 110,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.phoneverification);
                    },
                    label: Text('Phone'),
                    icon: Icon(Icons.phone_android),
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
