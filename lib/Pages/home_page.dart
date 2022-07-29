import 'dart:ui';

import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fireStore = FirebaseFirestore.instance;

  var dropdownvalue = "Type";
  var items = ["Type"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 23, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/logo.png",
                        width: 75,
                        height: 50,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Blog",
                        style: TextStyle(
                          // color: Color.fromARGB(255, 252, 62, 62),
                          color: const Color.fromARGB(255, 241, 21, 21),
                          fontFamily: ubuntuFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Icon(
                      Icons.search,
                      color: textColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection("blog").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return const Center(
                  //   child: SpinKitRing(
                  //     color: Colors.black,
                  //     size: 30,
                  //   ),
                  // );
                  return SpinKitRing(
                    color: textColor,
                    size: 30,
                    lineWidth: 4,
                  );
                }
                var mySnap = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: mySnap.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 23, left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(index);
                              setState(() {});
                            },
                            child: Text(
                              mySnap[index]["title"],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: ubuntuFont,
                                fontSize: 35,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                                color: textColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(mySnap[index]["date"])),
                                style: TextStyle(
                                  color: textColor,
                                  fontFamily: ubuntuFont,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            mySnap[index]["desc"],
                            style: TextStyle(
                              color: textColor,
                              fontFamily: ubuntuFont,
                              fontSize: 15,
                              height: 1.2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            itemCount: mySnap[index]["blogList"].length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              var lis = mySnap[index]["blogList"];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  lis[i]["type"] == "Image"
                                      ? Image.network(
                                          lis[i]["value"],
                                          height: 100,
                                          width: 100,
                                        )
                                      : Container(),
                                  lis[i]["type"] == "Text"
                                      ? Text(
                                          lis[i]["value"],
                                          style: TextStyle(
                                            color: textColor,
                                            fontFamily: ubuntuFont,
                                            fontSize: 15,
                                            height: 1.2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1000,
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Chip(
                            labelPadding: const EdgeInsets.all(2.0),
                            label: Text(
                              mySnap[index]["category"],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 2.0,
                            shadowColor: Colors.grey[60],
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
