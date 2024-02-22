import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studentdetails/screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   //  DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: InitializerWidget(),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth? auth;

  User? _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    _user = auth!.currentUser;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    print("uer ====== " + _user.toString());
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? LoginScreen()
            : HomeScreen();
  }
}
