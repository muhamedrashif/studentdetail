import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studentdetails/otp/otp.dart';
import 'package:studentdetails/resources/auth_methods.dart';
import 'package:studentdetails/screens/home_screen.dart';
import 'package:studentdetails/util/util.dart';
import 'package:studentdetails/widget/text_field_input.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (res == "success") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
 // show the error
      if (context.mounted) {
        showSnackBar(res, context);
      }   
         }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateTosingUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void navigateTootp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OtpLoginScreen()));
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
      // User? user = result.user;
      final authCredential123 = await auth.signInWithCredential(authCredential);

      if (authCredential123 != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 80),
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
                        validator: (value) {
                           if (value!.isEmpty) {
                            return 'Enter your email';
                          } else if (value.length < 6) {
                            return "Please enter correct password";
                          }
                        },
                      ),
                    ),
                    //forgotpassword
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // button login
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: InkWell(
                        onTap: loginUser,
                        //  onTap: navigateTohome,
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
                          onTap: navigateTosingUp,
                          child: Container(
                            child: const Text(
                              "Signup.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
          )),
    );
  }
}
