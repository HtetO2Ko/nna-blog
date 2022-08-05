import 'package:blog/Pages/add_items_page.dart';
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

  _tableTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

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
            const SizedBox(
              height: 40,
            ),
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
                  width: 120,
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
                            "Add Item",
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
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: DataTable(
                      border: TableBorder.all(
                        width: 0.2,
                        color: Colors.grey,
                      ),
                      columns: [
                        DataColumn(
                          label: _tableTitle("Title"),
                        ),
                        DataColumn(
                          label: _tableTitle("Description"),
                        ),
                        DataColumn(
                          label: _tableTitle("Date"),
                        ),
                        DataColumn(
                          label: _tableTitle("Category"),
                        ),
                        DataColumn(
                          label: _tableTitle("Action"),
                        ),
                      ],
                      rows: [
                        for (var i = 0; i < mySnap.length; i++)
                          DataRow(
                            color: MaterialStateColor.resolveWith((states) {
                              return i.isOdd
                                  ? const Color.fromARGB(255, 207, 224, 255)
                                  : Colors.white;
                            }),
                            cells: <DataCell>[
                              DataCell(
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    mySnap[i]["title"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    mySnap[i]["date"],
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
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
                                        List myList = [];
                                        myList.add(mySnap[i].data());
                                        Navigator.pushNamed(
                                          context,
                                          "/admin/edit-items",
                                          arguments: EditArguments(
                                            mySnap[i].reference.id,
                                            myList,
                                          ),
                                        );
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
                                                  Navigator.pop(context);
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
