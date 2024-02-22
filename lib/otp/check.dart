
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:studentdetails/screens/home_screen.dart';

// import 'otp.dart';


// class InitializerWidget extends StatefulWidget {
//   @override
//   _InitializerWidgetState createState()=> _InitializerWidgetState();
// }
// class _InitializerWidgetState extends State<InitializerWidget> {
//   FirebaseAuth? auth;

//   User? _user;

//   bool _isLoading=true;

//   @override
//   void initState(){
//     super.initState();
//     auth=FirebaseAuth.instance;
//     _isLoading=false;
//   }
//   @override
//   Widget build(BuildContext context){
//     return _isLoading 
//     ? Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     )
//     :
//     _user==null
//     ? OtpLoginScreen()
//     : HomeScreen();
//   }
// }