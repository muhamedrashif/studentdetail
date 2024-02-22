import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentdetails/resources/firestore_method.dart';
import 'package:studentdetails/screens/home_screen.dart';
import 'package:studentdetails/util/util.dart';
import 'package:studentdetails/widget/text_field_input.dart';

class AddStudentScreen extends StatefulWidget {
  final uid;
  const AddStudentScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _imageFile;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
  }

  void uploadStudentdetails(
    String name,
    String age,
    String photoUrl,
    String uid,
  ) async {
    print("inside=========");
    setState(() {
      _isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (_imageFile != null) {
        try {
          showAlertDialog(context);

          String res = await FirestoreMethods().uploadStudentdetails(
              name: _nameController.text,
              age: _ageController.text,
              file: _imageFile!,
              uid: widget.uid);

          if (res == "success") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
            setState(() {
              _isLoading = false;
            });
            showSnackBar('Added', context);
            clearImage();
          } else {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(res, context);
          }
        } catch (e) {
          showSnackBar(e.toString(), context);
        }
      } else {
        showSnackBar("Please upload a photo", context);
      }
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
      _nameController.text;
      _ageController.text;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
            child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  40.0,
                ),
                child: Text(
                  "Ender Student Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.quicksand().fontFamily),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Stack(
                  children: [
                    _imageFile != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_imageFile!),
                            backgroundColor: Colors.transparent,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: Colors.transparent,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () => _selectImage(context),
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  textEditingController: _nameController,
                  hintText: 'Name',
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  textEditingController: _ageController,
                  hintText: 'Age',
                  textInputType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter age';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  onTap: () {
                    uploadStudentdetails(_nameController.text,
                        _ageController.text, _imageFile.toString(), widget.uid);
                  },
                  child: Container(
                    child: const Text('Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
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
            ],
          ),
        )),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Icon(Icons.group),
          ),
        ),
      ),
    );
  }
}
