import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studentdetails/otp/otp.dart';
import 'package:studentdetails/util/util.dart';
import 'package:studentdetails/resources/auth_methods.dart';
import 'package:studentdetails/screens/login_screen.dart';
import 'package:studentdetails/widget/text_field_input.dart';

import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // if string returned is sucess, user has been created
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(res, context);
        }
      }
    }
  }

  void navigateTosingIn() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signupWithgoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  void navigateTootp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OtpLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 80),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    "Hello!\nWelcome back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.quicksand().fontFamily),
                  ),
                ),
                // text field input for eamil
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                     if (value!.isEmpty) {
                            return 'Enter your email';
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                    },
                  ),
                ),

                // text feild input for password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                    maxLength: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                            return 'Enter your email';
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 characters";
                          }
                    
                    },
                  ),
                ),

                // button login
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: signUpUser,
                    child: Container(
                      child: const Text('Signin',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      width: MediaQuery.of(context).size.width / 2,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          )),
                          color: Colors.teal),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account? "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: navigateTosingIn,
                      child: Container(
                        child: const Text(
                          "Signin.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  ],
                ),
                new Divider(
                  endIndent: double.tryParse('40'),
                  indent: double.tryParse('40'),
                  color: Colors.black38,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () => signupWithgoogle(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/googlee.png'),
                          radius: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: navigateTootp,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/phonee.png'),
                          radius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
