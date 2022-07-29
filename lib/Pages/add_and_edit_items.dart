import 'dart:developer';
import 'dart:io';

import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';

class AddAndEditItemsPage extends StatefulWidget {
  int id;
  AddAndEditItemsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<AddAndEditItemsPage> createState() => _AddAndEditItemsPageState();
}

class _AddAndEditItemsPageState extends State<AddAndEditItemsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

  void _showForm() async {
    _categoryController.text = "";
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 231, 230, 230),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                hintText: "Category",
                hintStyle: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _fireStore.collection("category").add({
                  "category": _categoryController.text,
                }).then((val) {
                  getCategoryItems();
                  setState(() {});
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Create category',
              ),
            ),
          ],
        ),
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

  @override
  void initState() {
    getCategoryItems();
    super.initState();
  }

  late XFile tem;

  Future<void> _selectImage(int index) async {
    final XFile? pickedFile = (await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 10000,
      maxHeight: 10000,
      imageQuality: 0,
    ));
    // if (pickedFile == null) {
    //   blogList[index]["value"] = "";
    // } else {
    //   print(">>>>>>>>>>");
    //   final ref = FirebaseStorage.instance.ref();
    //   await ref.putFile(File(pickedFile.path));
    //   blogList[index]["value"] = await ref.getDownloadURL();
    // }
    // print(blogList);
    ////
    // blogList[index]["value"] =
    //     pickedFile == null ? "" : <XFile>[pickedFile][0].path.toString();
    blogList[index]["value"] = pickedFile?.path;
    tem = pickedFile!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  "Items",
                  style: TextStyle(
                    fontFamily: ubuntuFont,
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _date(context);
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.all(20.0),
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
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      // width: MediaQuery.of(context).size.width * 0.93,
                      width: 1275,
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
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Description",
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
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  _selectImage(index);
                                  setState(() {});
                                },
                                child: blogList[index]["value"] == ""
                                    ? const Text("Choose Image")
                                    : kIsWeb
                                        ? Image.network(
                                            blogList[index]["value"],
                                            height: 150,
                                          )
                                        : Image.file(
                                            File(blogList[index]["value"]),
                                            height: 150,
                                          ),
                              ),
                            )
                          : Container(),
                      blogList[index]["type"] == "Text"
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: TextField(
                                maxLines: 5,
                                onChanged: (value) {
                                  blogList[index]["value"] = value;
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Container(),
                      // blogList[index]["type"] == "Video"
                      //     ? Container()
                      //     : Container(),
                      // blogList[index]["type"] == "Code"
                      //     ? Container()
                      //     : Container(),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: DropdownButton<String>(
                  items: const [
                    DropdownMenuItem<String>(
                      child: Text("Image"),
                      value: "Image",
                    ),
                    DropdownMenuItem<String>(
                      child: Text("Text"),
                      value: "Text",
                    ),
                    // DropdownMenuItem<String>(
                    //   child: Text("Video"),
                    //   value: "Video",
                    // ),
                    // DropdownMenuItem<String>(
                    //   child: Text("Code"),
                    //   value: "Code",
                    // ),
                  ],
                  icon: Container(),
                  onChanged: (String? value) {
                    blogList.add({
                      "type": value,
                      "value": "",
                    });
                    setState(() {});
                  },
                  underline: Container(),
                  hint: const Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Colors.blue,
                  child: TextButton(
                    onPressed: () async {
                      if (_titleController.text == "" ||
                          _descriptionController.text == "" ||
                          category == "Category") {
                        showToast(context, "Add Items can't be blank!");
                      } else {
                        loading = true;
                        for (var i = 0; i < blogList.length; i++) {
                          if (blogList[i]["type"] == "Image" &&
                              blogList[i]["value"] != "") {
                            // final ref =
                            //     FirebaseStorage.instance.ref().child("blog");

                            // await ref.putFile(File(blogList[i]["value"]));
                            // print("IMG>>>");
                            // // blogList[i]["value"] = await ref.getDownloadURL();
                            print("START>>>");
                            // Create a Reference to the file
                            Reference ref = FirebaseStorage.instance
                                .ref()
                                .child('flutter-tests')
                                .child('/some-image.jpg');

                            XFile file = tem;

                            final metadata = SettableMetadata(
                              contentType: 'image/jpeg',
                              customMetadata: {'picked-file-path': file.path},
                            );

                            var uploadTask =
                                ref.putData(await file.readAsBytes(), metadata);
                            print("UPLOAD>>>> $uploadTask");
                            var getURL = await ref.getDownloadURL();
                            blogList[i]["value"] = getURL.toString();
                            print("FINISHED>>>>");
                          }
                        }
                        await _fireStore.collection("blog").add({
                          "date": date,
                          "category": category,
                          "title": _titleController.text,
                          "desc": _descriptionController.text,
                          "blogList": blogList
                        }).then((value) {
                          loading = false;
                        });
                        Navigator.pushNamed(context, "/admin/show-items");
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
                              "Add blog",
                              style: TextStyle(
                                fontFamily: ubuntuFont,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
