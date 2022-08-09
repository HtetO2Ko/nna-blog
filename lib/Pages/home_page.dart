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
  bool searchOpen = false;
  List allList = [];
  bool check = false;
  List searchList = [];
  var items = ["Category"];
  String category = "Category";
  final TextEditingController _searchController = TextEditingController();

  getCategoryItems() {
    items.clear();
    items = ["Category"];
    _fireStore.collection('category').get().then((snapshot) {
      for (var docs in snapshot.docs) {
        items.add(docs.get("category"));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getCategoryItems();
    popupMenuItemwidth = 150;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection("blog").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            allList = mySnap;
            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 15, top: 10),
                      child: Text(
                        "Mr. Hunger",
                        style: TextStyle(
                          color: const Color(0xFFD61C4E),
                          fontFamily: ubuntuFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 15, top: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 170,
                            height: 53,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 233, 231, 231)),
                            ),
                            child: PopupMenuButton(
                              color: Colors.white,
                              tooltip: "",
                              itemBuilder: (context) => [
                                for (var i = 0; i < items.length; i++)
                                  PopupMenuItem(
                                    onTap: () {
                                      category = items[i];
                                      if (searchOpen == true) {
                                        if (category == "Category" &&
                                            _searchController.text == "") {
                                          searchList.clear();
                                          check = false;
                                        } else {
                                          print(
                                              ">>>>>>>>>> is searchopen true");
                                          searchList.clear();
                                          for (var a = 0;
                                              a < allList.length;
                                              a++) {
                                            if (category ==
                                                    allList[a]["category"] &&
                                                allList[a]["title"]
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase())) {
                                              searchList.add(allList[a]);
                                            }
                                          }
                                        }
                                      } else {
                                        print(">>>>>>>>>> is searchopen false");
                                        if (category == "Category") {
                                          searchList.clear();
                                          check = false;
                                        } else {
                                          searchList.clear();
                                          for (var a = 0;
                                              a < allList.length;
                                              a++) {
                                            if (category ==
                                                allList[a]["category"]) {
                                              searchList.add(allList[a]);
                                            }
                                          }
                                        }
                                      }
                                      if (category != "Category") {
                                        check = searchList.isEmpty;
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      items[i],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 13,
                                    left: 13,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: category == "Category"
                                              ? Colors.black54
                                              : Colors.black,
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              offset: const Offset(0, 70),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          searchOpen == false
                              ? Container()
                              : Container(
                                  width: 150,
                                  child: TextField(
                                    controller: _searchController,
                                    onSubmitted: (value) {
                                      searchList.clear();
                                      if (category == "Category") {
                                        for (var i = 0;
                                            i < allList.length;
                                            i++) {
                                          if (allList[i]["title"]
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            searchList.add(allList[i]);
                                          }
                                        }
                                      } else {
                                        for (var i = 0;
                                            i < allList.length;
                                            i++) {
                                          if (category ==
                                                  allList[i]["category"] &&
                                              allList[i]["title"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase())) {
                                            searchList.add(allList[i]);
                                          }
                                        }
                                      }
                                      check = searchList.isEmpty;
                                      print(
                                          ">>>>>>>>>>>>>>>>>>>>> searchList : $searchList");
                                      setState(() {});
                                    },
                                    // onChanged: (value) {
                                    //   if (category == "Category") {
                                    //     searchList.clear();
                                    //   }
                                    //   setState(() {});
                                    // },
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                            255,
                                            212,
                                            211,
                                            211,
                                          ),
                                        ),
                                      ),
                                      hintText: "Search",
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                            255,
                                            212,
                                            211,
                                            211,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          FlatButton(
                            minWidth: 25,
                            height: 50,
                            splashColor: Colors.white,
                            highlightColor: Colors.white,
                            hoverColor: Colors.white,
                            onPressed: () {
                              if (searchOpen == true) {
                                searchOpen = false;
                                _searchController.text = "";
                                if (category == "Category") {
                                  searchList.clear();
                                  check = false;
                                } else {
                                  searchList.clear();
                                  for (var a = 0; a < allList.length; a++) {
                                    if (category == allList[a]["category"]) {
                                      searchList.add(allList[a]);
                                    }
                                  }
                                }
                              } else {
                                searchOpen = true;
                              }
                              check = false;
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
                  ],
                ),
                searchList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              width: 900,
                              margin: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  // List myList = [];
                                  // myList.add(searchList[index].data());
                                  var docId = searchList[index].reference.id;
                                  Navigator.pushNamed(
                                    context,
                                    "/details/$docId",
                                    arguments: DetailsArguments(
                                      docId,
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchList[index]["title"],
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: ubuntuFont,
                                            fontSize: 35,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                        searchList[index]
                                                            ["date"])),
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
                                          searchList[index]["desc"],
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Chip(
                                              labelPadding:
                                                  const EdgeInsets.all(2.0),
                                              label: Text(
                                                searchList[index]["category"],
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: ubuntuFont,
                                                  fontSize: 15,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                              backgroundColor: Colors.white,
                                              elevation: 2.0,
                                              shadowColor: Colors.grey[60],
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                      )
                    : check == true
                        ? const Center(
                            child: Text(
                              "No data",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          )
                        : ListView.builder(
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
                                      // List myList = [];
                                      // myList.add(mySnap[index].data());
                                      var docId = mySnap[index].reference.id;
                                      // _fireStore
                                      //     .collection("blog")
                                      //     .doc(id)
                                      //     .get();
                                      Navigator.pushNamed(
                                        context,
                                        "/details/$docId",
                                        arguments: DetailsArguments(
                                          docId,
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: 15,
                                                    color: textColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    DateFormat("dd-MM-yyyy")
                                                        .format(DateTime.parse(
                                                            mySnap[index]
                                                                ["date"])),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Chip(
                                                  labelPadding:
                                                      const EdgeInsets.all(2.0),
                                                  label: Text(
                                                    mySnap[index]["category"],
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: ubuntuFont,
                                                      fontSize: 15,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  elevation: 2.0,
                                                  shadowColor: Colors.grey[60],
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
