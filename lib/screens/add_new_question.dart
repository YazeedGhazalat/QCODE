import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;
import '../models/user.dart' as u;
import '../extentions/error.dart' as e;
import '../extentions/successfull.dart';
import '../models/question_types.dart';
import '../widgets/TextCode.dart';

class AddNewQuestions extends StatefulWidget {
  AddNewQuestions({super.key});

  @override
  State<AddNewQuestions> createState() => _AddNewQuestionsState();
}

class _AddNewQuestionsState extends State<AddNewQuestions> {
  //final List<XFile?> _images = [];
  final u.User _user = u.User.getInstance();

  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _details['images'].add(image);
      });
    }
    return;
  }

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _details = {
    //"userId" : FirebaseAuth.instance.currentUser!.uid,
    "title": "",
    "description": "",
    "images": <XFile>[],
    "type": "Others",
    "code": "null",
  };
  Future _addNewQuestion(Function rebuild) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = !_isLoading;
      });
      try {
        await _user.addNewQuestion(_details);
        Successfull.snackBarError("New Question Added Successfully", context);
        Navigator.of(context).pop();
        rebuild();
      } catch (err) {
        e.Error.snackBarError(err.toString(), context);
      }
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  bool _isLoading = false;
  bool _isCodeShow = false;
  @override
  void initState() {
    TextCode.textCodeEditor = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function rebuild = ModalRoute.of(context)!.settings.arguments as Function;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add post"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _details['images'].clear();
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () async {
                      await _addNewQuestion(rebuild);
                    },
                    child: const Text("Post"),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category",
                    style: TextStyle(color: Colors.grey),
                    
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton(
                    value: _details['type'],
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: QuestionType.types.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (dynamic newValue) {
                      setState(() {
                        _details['type'] = newValue!.toString();
                        TextCode.type = _details['type'];
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 80,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the title";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Title",
                    //border: InputBorder.none,
                  ),
                  onSaved: (value) {
                    _details['title'] = value;
                  },
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade100,
                //     borderRadius: BorderRadius.circular(30),
                //   ),
                //   child: TextFormField(
                //     maxLength: 80,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Please enter the title";
                //       }
                //       return null;
                //     },
                //     decoration: const InputDecoration(
                //       hintText: "Title",
                //       border: InputBorder.none,
                //     ),
                //     onSaved: (value) {
                //       _details['title'] = value;
                //     },
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return "Please enter the description";
                  //   }
                  //   return null;
                  // },
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    //border: InputBorder.none,
                  ),
                  onSaved: (value) {
                    _details['description'] = value;
                  },
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade100,
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Please enter the description";
                //       }
                //       return null;
                //     },
                //     maxLines: 10,
                //     decoration: const InputDecoration(
                //       hintText: "Description",
                //       border: InputBorder.none,
                //     ),
                //     onSaved: (value) {
                //       _details['description'] = value;
                //     },
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCodeShow = !_isCodeShow;
                    });
                  },
                  icon: Icon(Icons.code),
                  label: Text(_isCodeShow ? "Remove code" : "Add code"),
                ),
                if (_isCodeShow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please add code here";
                        }
                        return null;
                      },
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Add code",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          TextCode.textCodeEditor =
                              value == null ? null : value;
                        });
                      },
                      onSaved: (value) {
                        _details['code'] = value;
                      },
                    ),
                  ),
                if (_isCodeShow) TextCode(),
                Column(
                  children: List.generate(
                    _details['images'].length,
                    (index) => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            i.File(_details['images'][index]!.path),
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        await _pickImage();
                      },
                      icon: const FaIcon(FontAwesomeIcons.images),
                      label: const Text("Add photo"),
                    ),
                    TextButton.icon(
                      label: Text("Scan"),
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: (() {
                        Navigator.pushNamed(context, '/image_Too_text');
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
