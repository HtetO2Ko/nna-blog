// import 'dart:io';

// import 'package:blog/common.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';

// class AddAndEditItemsPage extends StatefulWidget {
//   int id;
//   AddAndEditItemsPage({Key? key, required this.id}) : super(key: key);

//   @override
//   State<AddAndEditItemsPage> createState() => _AddAndEditItemsPageState();
// }

// class _AddAndEditItemsPageState extends State<AddAndEditItemsPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   bool show = false;
//   bool loading = false;
//   final _fireStore = FirebaseFirestore.instance;
//   String category = "Category";
//   var items = ["Category"];
//   final ImagePicker _picker = ImagePicker();
//   List blogList = [];
//   bool kIsWeb = identical(0, 0.0);

//   void _showForm() async {
//     _categoryController.text = "";
//     showModalBottomSheet(
//       context: context,
//       elevation: 5,
//       isScrollControlled: true,
//       builder: (_) => Container(
//         padding: EdgeInsets.only(
//           top: 15,
//           left: 15,
//           right: 15,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 25,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             TextFormField(
//               controller: _categoryController,
//               decoration: const InputDecoration(
//                 filled: true,
//                 fillColor: Color.fromARGB(255, 231, 230, 230),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10.0),
//                   ),
//                   borderSide: BorderSide.none,
//                 ),
//                 hintText: "Category",
//                 hintStyle: TextStyle(
//                   color: Colors.black45,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _fireStore.collection("category").add({
//                   "category": _categoryController.text,
//                 }).then((val) {
//                   getCategoryItems();
//                   setState(() {});
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'Create category',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _date(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2019),
//         lastDate: DateTime(2100));
//     if (picked != null) {
//       setState(() {
//         date = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   getCategoryItems() {
//     items.clear();
//     items = ["Category"];
//     _fireStore.collection('category').get().then((snapshot) {
//       for (var docs in snapshot.docs) {
//         items.add(docs.get("category"));
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void initState() {
//     getCategoryItems();
//     super.initState();
//   }

//   late XFile tem;

//   Future<void> _selectImage(int index) async {
//     final XFile? pickedFile = (await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 10000,
//       maxHeight: 10000,
//       imageQuality: 0,
//     ));
//     blogList[index]["value"] = pickedFile?.path;
//     tem = pickedFile!;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: Text(
//                   "Items",
//                   style: TextStyle(
//                     fontFamily: ubuntuFont,
//                     color: Colors.black,
//                     fontSize: 23,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _date(context);
//                   setState(() {});
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.all(20.0),
//                   padding: const EdgeInsets.only(
//                       left: 15, right: 15, top: 12, bottom: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black26,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontFamily: ubuntuFont,
//                         ),
//                       ),
//                       const Icon(
//                         Icons.calendar_month_outlined,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.08,
//                       // width: MediaQuery.of(context).size.width * 0.93,
//                       width: 1275,
//                       child: DropdownButtonFormField(
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                         ),
//                         value: category,
//                         items: items.map((String items) {
//                           return DropdownMenuItem(
//                             value: items,
//                             child: Text(items),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           category = value.toString();
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       child: TextButton(
//                         onPressed: () {
//                           _showForm();
//                           setState(() {});
//                         },
//                         child: const Icon(
//                           Icons.add,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: "Title",
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: TextField(
//                   controller: _descriptionController,
//                   maxLines: 5,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: "Description",
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemCount: blogList.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       blogList[index]["type"] == "Image"
//                           ? Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 20, left: 20, right: 20),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   _selectImage(index);
//                                   setState(() {});
//                                 },
//                                 child: blogList[index]["value"] == ""
//                                     ? const Text("Choose Image")
//                                     : kIsWeb
//                                         ? Image.network(
//                                             blogList[index]["value"],
//                                             height: 150,
//                                           )
//                                         : Image.file(
//                                             File(blogList[index]["value"]),
//                                             height: 150,
//                                           ),
//                               ),
//                             )
//                           : Container(),
//                       blogList[index]["type"] == "Text"
//                           ? Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 20, left: 20, right: 20),
//                               child: TextField(
//                                 maxLines: 5,
//                                 onChanged: (value) {
//                                   blogList[index]["value"] = value;
//                                   setState(() {});
//                                 },
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                       // blogList[index]["type"] == "Video"
//                       //     ? Container()
//                       //     : Container(),
//                       // blogList[index]["type"] == "Code"
//                       //     ? Container()
//                       //     : Container(),
//                     ],
//                   );
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: DropdownButton<String>(
//                   items: const [
//                     DropdownMenuItem<String>(
//                       child: Text("Image"),
//                       value: "Image",
//                     ),
//                     DropdownMenuItem<String>(
//                       child: Text("Text"),
//                       value: "Text",
//                     ),
//                     // DropdownMenuItem<String>(
//                     //   child: Text("Video"),
//                     //   value: "Video",
//                     // ),
//                     // DropdownMenuItem<String>(
//                     //   child: Text("Code"),
//                     //   value: "Code",
//                     // ),
//                   ],
//                   icon: Container(),
//                   onChanged: (String? value) {
//                     blogList.add({
//                       "type": value,
//                       "value": "",
//                     });
//                     setState(() {});
//                   },
//                   underline: Container(),
//                   hint: const Icon(Icons.add),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.07,
//                   color: Colors.blue,
//                   child: TextButton(
//                     onPressed: () async {
//                       if (_titleController.text == "" ||
//                           _descriptionController.text == "" ||
//                           category == "Category") {
//                         showToast(context, "Add Items can't be blank!");
//                       } else {
//                         loading = true;
//                         for (var i = 0; i < blogList.length; i++) {
//                           if (blogList[i]["type"] == "Image" &&
//                               blogList[i]["value"] != "") {
//                             print("START>>>");
//                             Reference ref = FirebaseStorage.instance
//                                 .ref()
//                                 .child('flutter-tests')
//                                 .child('/some-image.jpg');
//                             XFile file = tem;
//                             final metadata = SettableMetadata(
//                               contentType: 'image/jpeg',
//                               customMetadata: {'picked-file-path': file.path},
//                             );
//                             print(">>>>>>>>>>>>> file ${file.path}");
//                             var uploadTask =
//                                 ref.putData(await file.readAsBytes(), metadata);
//                             print("UPLOAD>>>> $uploadTask");
//                             var getURL = await ref.getDownloadURL();
//                             blogList[i]["value"] = getURL.toString();
//                             print("FINISHED>>>>");
//                           }
//                         }
//                         // await _fireStore.collection("blog").add({
//                         //   "date": date,
//                         //   "category": category,
//                         //   "title": _titleController.text,
//                         //   "desc": _descriptionController.text,
//                         //   "blogList": blogList
//                         // }).then((value) {
//                         //   loading = false;
//                         // });
//                         // Navigator.pushNamed(context, "/admin/show-items");
//                       }
//                       setState(() {});
//                     },
//                     child: Center(
//                       child: loading == true
//                           ? const SizedBox(
//                               width: 23,
//                               height: 23,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               "Add blog",
//                               style: TextStyle(
//                                 fontFamily: ubuntuFont,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 35,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

////
import 'dart:io';
import 'package:blog/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAndEditItemsPage extends StatefulWidget {
  int id;
  AddAndEditItemsPage({Key? key, required this.id}) : super(key: key);
  @override
  State<AddAndEditItemsPage> createState() => _AddAndEditItemsPageState();
}

class _AddAndEditItemsPageState extends State<AddAndEditItemsPage> {
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

  Future<void> _selectImage(int index) async {
    final XFile? pickedFile = (await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 10000,
      maxHeight: 10000,
      imageQuality: 0,
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
    return Scaffold(
      body: SafeArea(
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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        GestureDetector(
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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 815,
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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 815,
                                          child: TextField(
                                            maxLines: 1,
                                            onChanged: (value) {
                                              if (value != "") {
                                                getYoutubeVideoId(index, value);
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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 815,
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
                      // children: [
                      //   IconButton(
                      //     onPressed: () {
                      //       setState(() {});
                      //     },
                      //     icon: const Icon(
                      //       Icons.add,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   const SizedBox(
                      //     width: 25,
                      //   ),
                      //   GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(50),
                      //         border: Border.all(color: Colors.black),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(10.0),
                      //         child: Text(
                      //           "Text",
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   const SizedBox(
                      //     width: 25,
                      //   ),
                      //   GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(50),
                      //         border: Border.all(color: Colors.black),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(10.0),
                      //         child: Text(
                      //           "Image",
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   const SizedBox(
                      //     width: 25,
                      //   ),
                      //   GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(50),
                      //         border: Border.all(color: Colors.black),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(10.0),
                      //         child: Text(
                      //           "Video",
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   const SizedBox(
                      //     width: 25,
                      //   ),
                      //   GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(50),
                      //         border: Border.all(color: Colors.black),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(10.0),
                      //         child: Text(
                      //           "Code",
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      color: Colors.blue,
                      child: TextButton(
                        onPressed: () async {
                          if (_titleController.text == "" ||
                              category == "Category" ||
                              blogList.isEmpty) {
                            showToast(context, "Add Items can't be blank!");
                          } else {
                            loading = true;
                            var desc = "";
                            List g = [];
                            for (var a = 0; a < blogList.length; a++) {
                              if (blogList[a]["type"] == "Text") {
                                g.add(a);
                              }
                            }
                            desc = blogList[g[0]]["value"];
                            print("description is : $desc");
                            setState(() {});
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
                                  await _fireStore.collection("blog").add({
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
                                print(">>>>>>>>>> Contains");
                              } else {
                                await _fireStore.collection("blog").add({
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
                                _fireStore.collection("blog").doc("").update({
                                  "date": date,
                                  "category": category,
                                  "title": _titleController.text,
                                  "desc": desc,
                                  "blogList": blogList,
                                }).then((value) {
                                  loading = false;
                                });
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
                                  "Add blog",
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
    );
  }
}
