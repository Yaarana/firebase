import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newfb/utils/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogInpage extends StatefulWidget {
  const LogInpage({super.key});

  @override
  State<LogInpage> createState() => _LogInpageState();
}

class _LogInpageState extends State<LogInpage> {
  final _formkey = GlobalKey<FormState>();

// ---------------------------  google sign in --------------------------------------------
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
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 230,
                ),
                Container(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
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
                      textAlign: TextAlign.start,
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
                          suffixIcon: Icon(Icons.email),
                          suffixIconColor: Colors.grey,
                          border: InputBorder.none,
                          errorStyle: TextStyle(color: Colors.white)),
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
                          border: InputBorder.none,
                          errorStyle: TextStyle(color: Colors.white)),
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
                              .signInWithEmailAndPassword(
                                  email: email, password: pass);
                          Navigator.pushNamed(context, MyRoutes.homepage);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      }
                    },
                    child: Text(
                      'Log In',
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
                    Navigator.pushNamed(context, MyRoutes.registraion);
                  },
                  child: Text(
                    'Create New Account',
                    style: TextStyle(color: Colors.white, fontSize: 15),
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
