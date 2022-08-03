import 'package:blog/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool checkObscureText = true;
  final _fireStore = FirebaseFirestore.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "images/logo.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                          fontFamily: ubuntuFont,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 175, 211, 241),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 175, 211, 241),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontFamily: ubuntuFont,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: checkObscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              splashColor: Colors.white,
                              highlightColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  checkObscureText = !checkObscureText;
                                });
                              },
                              icon: Icon(
                                // checkObscureText
                                //     ? Icons.visibility
                                //     : Icons.visibility_off,
                                checkObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black45,
                              ),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 175, 211, 241),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 175, 211, 241),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: GestureDetector(
                onTap: () async {
                  List myList = [];
                  loading = true;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("username", _usernameController.text);
                  _fireStore.collection('login').get().then((snapshot) {
                    for (var docs in snapshot.docs) {
                      if (docs.get("username") != _usernameController.text ||
                          docs.get("password") != _passwordController.text) {
                        myList.add("false");
                      } else {
                        myList.add("true");
                      }
                    }
                    if (myList.contains("true")) {
                      loading = false;
                      Navigator.pushNamed(context, "/admin/show-items");
                    } else {
                      showToast(context, "Incorrect Password!");
                      loading = false;
                    }
                    setState(() {});
                  });
                  setState(() {});
                },
                child: loading == true
                    ? const SizedBox(
                        width: 23,
                        height: 23,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: ubuntuFont,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
