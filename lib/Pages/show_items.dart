import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowContentPage extends StatefulWidget {
  const ShowContentPage({Key? key}) : super(key: key);

  @override
  State<ShowContentPage> createState() => _ShowContentPageState();
}

class _ShowContentPageState extends State<ShowContentPage> {
  final _fireStore = FirebaseFirestore.instance;

  checkSharePreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString("username");
    if (userName == null) {
      Navigator.pushNamed(context, "/admin");
    }
    setState(() {});
  }

  @override
  void initState() {
    checkSharePreferenceData();
    super.initState();
  }

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
                  return const SpinKitRing(
                    color: Colors.black,
                    size: 30,
                    lineWidth: 4,
                  );
                }
                var mySnap = snapshot.data!.docs;
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: DataTable(
                      border: TableBorder.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      columns: const [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Title',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Category',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        for (var i = 0; i < mySnap.length; i++)
                          DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Container(
                                  width: 125,
                                  child: Text(
                                    mySnap[i]["title"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 125,
                                  child: Text(
                                    mySnap[i]["desc"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 125,
                                  child: Text(
                                    mySnap[i]["date"],
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 125,
                                  child: Text(
                                    mySnap[i]["category"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // mySnap[i].reference.update({
                                        //   "date": "2022-07-30",
                                        //   "category": "Personal",
                                        //   "title": "One Piece",
                                        //   "desc": "Luffy",
                                        //   "blogList": [],
                                        // });
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => AlertDialog(
                                            title: const Text(
                                                "Are you sure you want to delete this blog?"),
                                            content: Text(
                                              mySnap[i]['title'],
                                            ),
                                            actions: [
                                              FlatButton(
                                                color: Colors.blue,
                                                minWidth: 12,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: const Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              FlatButton(
                                                color: Colors.blue,
                                                minWidth: 12,
                                                onPressed: () {
                                                  mySnap[i].reference.delete();
                                                  setState(() {});
                                                },
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    // child: ListView.builder(
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: mySnap.length,
                    //   itemBuilder: (context, index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(
                    //           top: 12, left: 30, right: 30, bottom: 12),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   print(index);
                    //                   setState(() {});
                    //                 },
                    //                 child: Text(
                    //                   mySnap[index]["title"],
                    //                   style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontFamily: ubuntuFont,
                    //                     fontSize: 35,
                    //                   ),
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 children: [
                    //                   const Icon(
                    //                     Icons.calendar_month_outlined,
                    //                     size: 15,
                    //                     color: Colors.black,
                    //                   ),
                    //                   const SizedBox(
                    //                     width: 5,
                    //                   ),
                    //                   Text(
                    //                     DateFormat("dd-MM-yyyy").format(
                    //                         DateTime.parse(
                    //                             mySnap[index]["date"])),
                    //                     style: TextStyle(
                    //                       color: Colors.black,
                    //                       fontFamily: ubuntuFont,
                    //                       fontSize: 15,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               const SizedBox(
                    //                 height: 15,
                    //               ),
                    //               Text(
                    //                 mySnap[index]["desc"],
                    //                 style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontFamily: ubuntuFont,
                    //                   fontSize: 15,
                    //                   height: 1.2,
                    //                   overflow: TextOverflow.ellipsis,
                    //                 ),
                    //                 maxLines: 5,
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               IconButton(
                    //                 onPressed: () {
                    //                   mySnap[index].reference.update({
                    //                     "date": "2022-07-30",
                    //                     "category": "Personal",
                    //                     "title": "Naruto",
                    //                     "desc": "Boruto",
                    //                     "blogList": [],
                    //                   });
                    //                   setState(() {});
                    //                 },
                    //                 icon: const Icon(
                    //                   Icons.edit,
                    //                 ),
                    //               ),
                    //               IconButton(
                    //                 onPressed: () {},
                    //                 icon: const Icon(
                    //                   Icons.delete,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //     // return Padding(
                    //     //   padding: const EdgeInsets.only(top: 23),
                    //     //   child: Row(
                    //     //     mainAxisAlignment: MainAxisAlignment.start,
                    //     //     children: [
                    //     //       SizedBox(
                    //     //         width: MediaQuery.of(context).size.width * 0.2,
                    //     //       ),
                    //     //       Column(
                    //     //         crossAxisAlignment: CrossAxisAlignment.start,
                    //     //         children: [
                    //     //           GestureDetector(
                    //     //             onTap: () {
                    //     //               print(index);
                    //     //               setState(() {});
                    //     //             },
                    //     //             child: Text(
                    //     //               mySnap[index]["title"],
                    //     //               style: TextStyle(
                    //     //                 color: Colors.black,
                    //     //                 fontWeight: FontWeight.bold,
                    //     //                 fontFamily: ubuntuFont,
                    //     //                 fontSize: 35,
                    //     //               ),
                    //     //             ),
                    //     //           ),
                    //     //           const SizedBox(
                    //     //             height: 5,
                    //     //           ),
                    //     //           Row(
                    //     //             mainAxisAlignment: MainAxisAlignment.start,
                    //     //             children: [
                    //     //               const Icon(
                    //     //                 Icons.calendar_month_outlined,
                    //     //                 size: 15,
                    //     //                 color: Colors.black,
                    //     //               ),
                    //     //               const SizedBox(
                    //     //                 width: 5,
                    //     //               ),
                    //     //               Text(
                    //     //                 DateFormat("dd-MM-yyyy").format(
                    //     //                     DateTime.parse(mySnap[index]["date"])),
                    //     //                 style: TextStyle(
                    //     //                   color: Colors.black,
                    //     //                   fontFamily: ubuntuFont,
                    //     //                   fontSize: 15,
                    //     //                 ),
                    //     //               ),
                    //     //             ],
                    //     //           ),
                    //     //           const SizedBox(
                    //     //             height: 15,
                    //     //           ),
                    //     //           Container(
                    //     //             width: 800,
                    //     //             child: Text(
                    //     //               mySnap[index]["desc"],
                    //     //               style: TextStyle(
                    //     //                 color: Colors.black,
                    //     //                 fontFamily: ubuntuFont,
                    //     //                 fontSize: 15,
                    //     //                 height: 1.2,
                    //     //                 overflow: TextOverflow.ellipsis,
                    //     //               ),
                    //     //               maxLines: 5,
                    //     //             ),
                    //     //           ),
                    //     //         ],
                    //     //       ),
                    //     //       SizedBox(
                    //     //         width: MediaQuery.of(context).size.width * 0.2,
                    //     //       ),
                    //     //     ],
                    //     //   ),
                    //     // );
                    //   },
                    // ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
