import 'package:blog/Pages/details_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
          child: Text(
            "Mr. Hunger",
            style: TextStyle(
              color: const Color(0xFFD61C4E),
              fontFamily: ubuntuFont,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
            child: TextButton(
              onPressed: () {
                setState(() {});
              },
              child: Icon(
                Icons.search,
                color: textColor,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("blog").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCube(
                color: textColor,
                size: 30,
              ),
            );
          }
          var mySnap = snapshot.data!.docs;
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: mySnap.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        width: 900,
                        margin: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            List myList = [];
                            myList.add(mySnap[index].data());
                            Navigator.pushNamed(
                              context,
                              "/details",
                              arguments: DetailsArguments(myList),
                            );
                            setState(() {});
                          },
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mySnap[index]["title"],
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ubuntuFont,
                                      fontSize: 35,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
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
                                              DateTime.parse(
                                                  mySnap[index]["date"])),
                                          style: TextStyle(
                                            color: textColor,
                                            fontFamily: ubuntuFont,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      height: 1.8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 5,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Chip(
                                        labelPadding: const EdgeInsets.all(2.0),
                                        label: Text(
                                          mySnap[index]["category"],
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: ubuntuFont,
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                        backgroundColor: Colors.white,
                                        elevation: 2.0,
                                        shadowColor: Colors.grey[60],
                                        padding: const EdgeInsets.all(8.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
