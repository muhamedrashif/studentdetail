import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentdetails/resources/auth_methods.dart';
import 'addstudent-screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List _searchItems = [];
  List _resultList = [];
  double start = 20.0;
  double end = 30.0;
  bool isShow = false;
  double selectedstart = 0.1;
  double selectedend = 30.0;

  void navigateToaddStudent() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AddStudentScreen(uid: FirebaseAuth.instance.currentUser!.uid)));
  }

  @override
  void initState() {
    getStudent();
    _searchController.addListener(_onsearchChanged);
    super.initState();
  }

  _onsearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var studentSnapshot in _searchItems) {
        var name = studentSnapshot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(studentSnapshot);
        }
      }
    } else {
      showResults = List.from(_searchItems);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  ageResultList() {
    var showResults = [];
    if (selectedstart != 0.1) {
      for (var studentSnapshot in _searchItems) {
        var name = studentSnapshot['age'].toString().toLowerCase();
        if (double.parse(name) > selectedstart &&
            double.parse(name) < selectedend) {
          showResults.add(studentSnapshot);
        }
      }
    } else {
      showResults = List.from(_searchItems);
      print("length================================" +
          showResults.length.toString());
    }
    setState(() {
      _resultList = showResults;
    });

    print(
        "_resultList age limitation ======= " + _resultList.length.toString());
  }

  getStudent() async {
    print("current uid =============== " +
        FirebaseAuth.instance.currentUser!.uid.toString());
    var data = await FirebaseFirestore.instance
        .collection('studentdetails')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _searchItems = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.removeListener(_onsearchChanged);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Details",
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[200],
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              onPressed: () async {
                await AuthMethods().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    isShow = true;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Age Range " +
                        start.toStringAsFixed(2) +
                        " - " +
                        end.toStringAsFixed(2)),
                  ),
                  Container(
                    child: RangeSlider(
                      divisions: 5,
                      values: RangeValues(start, end),
                      labels: RangeLabels(start.toString(), end.toString()),
                      onChanged: (value) {
                        setState(() {
                          start = value.start;
                          end = value.end;
                          selectedstart = value.start;
                          selectedend = value.end;
                        });
                        ageResultList();
                      },
                      min: 0.0,
                      max: 50.0,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: _searchItems.isEmpty || _resultList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              _resultList.isEmpty
                                  ? "No data found!!"
                                  : "No data available!!\nTap on Add Student for insert data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily),
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _resultList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.teal[200]),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        _resultList[index]['photoUrl']),
                                    radius: 22,
                                  ),
                                  title: Text(_resultList[index]['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(_resultList[index]['age']),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: navigateToaddStudent,
              label: const Text('Add Student'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      )),
    );
  }
}
