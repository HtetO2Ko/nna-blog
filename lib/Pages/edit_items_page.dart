import 'dart:io';
import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditItemsPage extends StatefulWidget {
  const EditItemsPage({Key? key}) : super(key: key);
  @override
  State<EditItemsPage> createState() => _EditItemsPageState();
}

class _EditItemsPageState extends State<EditItemsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool show = false;
  bool loading = false;
  final _fireStore = FirebaseFirestore.instance;
  String category = "Category";
  var items = ["Category"];
  final ImagePicker _picker = ImagePicker();
  List blogList = [];
  bool kIsWeb = identical(0, 0.0);
  bool isOpen = false;
  List getEditDataList = [];
  String docId = "";
  List<TextEditingController> _textController = [];
  late List<TextEditingController> _videoController = [];
  late List<TextEditingController> _codeController = [];

  void _showForm() async {
    _categoryController.text = "";
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Container(),
        content: TextFormField(
          controller: _categoryController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: "Category",
            hintStyle: TextStyle(
              color: Colors.black45,
            ),
          ),
        ),
        actions: [
          FlatButton(
            color: Colors.blue,
            minWidth: 12,
            onPressed: () {
              _fireStore.collection("category").add({
                "category": _categoryController.text,
              }).then((val) {
                getCategoryItems();
                setState(() {});
              });
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _date(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        date = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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

  Future<void> _selectImage(int index) async {
    final XFile? pickedFile = (await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 100,
    ));
    late XFile tem;
    tem = pickedFile!;
    blogList[index]["file"] = tem;
    blogList[index]["value"] = pickedFile.path;
    setState(() {});
  }

  getYoutubeVideoId(int index, youtubeURL) {
    RegExp regExp = RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    if (youtubeURL != "") {
      try {
        final match = regExp.firstMatch(youtubeURL)!.group(1);
        String youtubeID = match!;
        print(">>>>>>>>>>> youtubeID :  $youtubeID");
        blogList[index]["value"] = youtubeID;
      } catch (e) {
        showToast(context, "Wrong youtube link!");
      }
    }
    setState(() {});
  }

  _widget(image) {
    return GestureDetector(
      onTap: () {
        if (image == "text") {
          _textController.add(TextEditingController());
          blogList.add({
            "type": "Text",
            "value": "",
          });
        } else if (image == "image") {
          blogList.add({
            "type": "Image",
            "value": "",
            "file": XFile,
          });
        } else if (image == "video") {
          blogList.add({
            "type": "Video",
            "value": "",
            "link": "",
          });
        } else if (image == "code") {
          blogList.add({
            "type": "Code",
            "value": "",
          });
        }
        isOpen = false;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            "images/$image.png",
            width: 35,
            height: 30,
          ),
        ),
      ),
    );
  }

  checkSharePreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString("username");
    if (userName == null) {
      Navigator.pushNamed(context, "/admin");
    } else {
      getCategoryItems();
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
    final args = ModalRoute.of(context)!.settings.arguments as EditArguments;
    getEditDataList = args.lis;
    docId = args.docId;
    _titleController.text = getEditDataList[0]["title"];
    category = getEditDataList[0]["category"];
    date = getEditDataList[0]["date"];
    blogList = getEditDataList[0]["blogList"];
    for (var i = 0; i < blogList.length; i++) {
      if (blogList[i]["type"] == "Text") {
        _textController.add(TextEditingController());
        _textController[i].text = blogList[i]["value"];
      } else if (blogList[i]["type"] == "Code") {
        _codeController.add(TextEditingController());
        _codeController[i].text = blogList[i]["value"];
      }
    }
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, "/admin/show-items");
          setState(() {});
          return false;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Items",
                      style: TextStyle(
                        fontFamily: ubuntuFont,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _date(context);
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 12, bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(DateTime.parse(date)),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: ubuntuFont,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 815,
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                value: category,
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  category = value.toString();
                                  setState(() {});
                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  _showForm();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Title",
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: blogList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              blogList[index]["type"] == "Image"
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _selectImage(index);
                                              setState(() {});
                                            },
                                            child:
                                                blogList[index]["value"] == ""
                                                    ? const Text("Choose Image")
                                                    : kIsWeb
                                                        ? Image.network(
                                                            blogList[index]
                                                                ["value"],
                                                            height: 150,
                                                          )
                                                        : Image.file(
                                                            File(blogList[index]
                                                                ["value"]),
                                                            height: 150,
                                                          ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              blogList.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              blogList[index]["type"] == "Text"
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 815,
                                            child: TextField(
                                              maxLines: 5,
                                              controller:
                                                  _textController[index],
                                              onChanged: (value) {
                                                blogList[index]["value"] =
                                                    value;
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              blogList.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              blogList[index]["type"] == "Video"
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 815,
                                            child: TextField(
                                              maxLines: 1,
                                              onChanged: (value) {
                                                blogList[index]["link"] = value;
                                                if (value != "") {
                                                  getYoutubeVideoId(
                                                      index, value);
                                                }
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              blogList.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              blogList[index]["type"] == "Code"
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 815,
                                            child: TextField(
                                              maxLines: 5,
                                              onChanged: (value) {
                                                blogList[index]["value"] =
                                                    value;
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              blogList.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isOpen == false) {
                                isOpen = true;
                              } else {
                                isOpen = false;
                              }
                              setState(() {});
                            },
                            icon: isOpen == true
                                ? const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          isOpen == false
                              ? Container()
                              : Row(
                                  children: [
                                    _widget("text"),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    _widget("image"),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    _widget("video"),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    _widget("code"),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        color: Colors.black,
                        child: TextButton(
                          onPressed: () async {
                            if (_titleController.text == "" ||
                                category == "Category" ||
                                blogList.isEmpty) {
                              showToast(context, "Add Items can't be blank!");
                            } else {
                              loading = true;
                              var desc = "";
                              List checkList = [];
                              for (var a = 0; a < blogList.length; a++) {
                                if (blogList[a]["value"] == "") {
                                  checkList.add("true");
                                }
                              }
                              print(checkList);
                              setState(() {});
                              if (checkList.contains("true")) {
                                showToast(context, "No post will be added");
                                Navigator.pushNamed(
                                    context, "/admin/show-items");
                              } else {
                                List getFirstText = [];
                                for (var a = 0; a < blogList.length; a++) {
                                  if (blogList[a]["type"] == "Text") {
                                    getFirstText.add(a);
                                  }
                                }
                                if (getFirstText.isNotEmpty) {
                                  desc = blogList[getFirstText[0]]["value"];
                                }
                                List checkImage = [];
                                for (var i = 0; i < blogList.length; i++) {
                                  if (blogList[i]["type"] == "Image" &&
                                      blogList[i]["value"] != "") {
                                    print("START>>>");
                                    checkImage.add("true");
                                    XFile file = blogList[i]["file"];
                                    Reference ref = FirebaseStorage.instance
                                        .ref()
                                        .child("nna-blog")
                                        .child("${blogList[i]["value"]}.jpg");
                                    final metadata = SettableMetadata(
                                      contentType: 'image/jpeg',
                                      customMetadata: {
                                        'picked-file-path': file.path
                                      },
                                    );
                                    var uploadTask = ref.putData(
                                        await file.readAsBytes(), metadata);
                                    print("upload >>>> $uploadTask");
                                    uploadTask.whenComplete(() async {
                                      var getURL = await ref.getDownloadURL();
                                      print(">>>> url $getURL");
                                      blogList[i]["value"] = getURL.toString();
                                      blogList[i]["file"] = "test";
                                      print("FINISHED>>>>");
                                      await _fireStore
                                          .collection("blog")
                                          .doc()
                                          .update({
                                        "date": date,
                                        "category": category,
                                        "title": _titleController.text,
                                        "desc": desc,
                                        "blogList": blogList,
                                      }).then((value) {
                                        loading = false;
                                      });
                                      Navigator.pushNamed(
                                          context, "/admin/show-items");
                                      print("pushed");
                                      setState(() {});
                                    });
                                  } else {
                                    checkImage.add("false");
                                  }
                                  setState(() {});
                                }
                                for (var i = 0; i < checkImage.length; i++) {
                                  if (checkImage.contains("true")) {
                                  } else {
                                    await _fireStore
                                        .collection("blog")
                                        .doc()
                                        .update({
                                      "date": date,
                                      "category": category,
                                      "title": _titleController.text,
                                      "desc": desc,
                                      "blogList": blogList,
                                    }).then((value) {
                                      loading = false;
                                    });
                                    Navigator.pushNamed(
                                        context, "/admin/show-items");
                                    print("pushed");
                                  }
                                }
                              }
                              setState(() {});
                            }
                            setState(() {});
                          },
                          child: Center(
                            child: loading == true
                                ? const SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Edit Blog",
                                    style: TextStyle(
                                      fontFamily: ubuntuFont,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
