import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ShowContentPage extends StatefulWidget {
  const ShowContentPage({Key? key}) : super(key: key);

  @override
  State<ShowContentPage> createState() => _ShowContentPageState();
}

class _ShowContentPageState extends State<ShowContentPage> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Items",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/admin/add-items");
                      setState(() {});
                    },
                    child: Center(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            "Add item",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                    color: Colors.black,
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
                                color: Colors.black,
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
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(mySnap[index]["date"])),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: ubuntuFont,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SelectableText(
                            mySnap[index]["desc"],
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: ubuntuFont,
                              fontSize: 15,
                              height: 1.2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            showCursor: true,
                            maxLines: 5,
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
