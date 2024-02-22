import 'dart:developer';
import 'package:country_list_pick/support/code_country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:studentdetails/screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class OtpLoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<OtpLoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  var formkey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  var verificationId;

  bool showLoading = false;
  var phonenumber;
  var otp;
  CountryCode? countryCode;
  var size, height, width;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getMobileFormWidget(context) {
    return Form(
      key: formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Enter your mobile number ,we will \nsend you otp to verify !!',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: IntlPhoneField(
                          controller: phoneController,
                          flagsButtonPadding:
                              const EdgeInsets.only(bottom: 9, left: 12),
                          dropdownIconPosition: IconPosition.trailing,
                          disableLengthCheck: false,
                          dropdownIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.transparent,
                          ),
                          decoration: const InputDecoration(
                              hintText: 'Phone number',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            setState(() {
                              phonenumber = phone.completeNumber;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      log(phonenumber.toString());
                      setState(() {
                        showLoading = true;
                      });

                      await _auth.verifyPhoneNumber(
                        phoneNumber: phonenumber.toString(),
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            showLoading = false;
                          });
                        },
                        verificationFailed: (verificationFailed) async {
                          setState(() {
                            showLoading = false;
                          });
                          print("verificationFailed message" +
                              verificationFailed.message.toString());
                        },
                        codeSent: (verificationId, resendingToken) async {
                          setState(() {
                            showLoading = false;
                            currentState =
                                MobileVerificationState.SHOW_OTP_FORM_STATE;
                            this.verificationId = verificationId;
                          });
                        },
                        codeAutoRetrievalTimeout: (verificationId) async {},
                      );
                    },
                    child: Container(
                      child: showLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('REQUEST OTP',
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
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'OTP has been sent to you on your mobile\n number please enter it below',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'ENTER OTP',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Pinput(
                  defaultPinTheme: PinTheme(
                      height: 50.0,
                      width: 50.0,
                      textStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.teal.withOpacity(0.5),
                              width: 1.0))),
                  length: 6,
                  onChanged: (val) {
                    if (val.length == 6) {
                      otp = val;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      showLoading = true;
                    });
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otp.toString());

                    signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  child: Container(
                    child: showLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Verify',
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
              )
            ]),
          ),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    height = size.height;
    width = size.width;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
