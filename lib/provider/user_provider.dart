import 'package:flutter/widgets.dart';
import 'package:studentdetails/models/user.dart';
import 'package:studentdetails/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  late User user;
  bool loading = false;

  rerfreshUser() async {
    loading = true;

    user = (await AuthMethods().getUserdetails());
    loading = false;

    notifyListeners();
  }
}
