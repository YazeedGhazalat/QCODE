import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stackexchange/models/home_provider.dart';
import '../widgets/question.dart';
import '../models/question.dart' as q;
import '../widgets/waiting_questions.dart';

class MyQuestions extends StatefulWidget {
  MyQuestions({super.key});

  @override
  State<MyQuestions> createState() => _MyQuestionsState();
}

class _MyQuestionsState extends State<MyQuestions> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Questions")
            .where("userId", isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerWaiting();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You didn't add any post"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_new_question',arguments: (){});
                    },
                    child: Text("Add Post"),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.hasData ? snapshot.data!.docs : [];
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 10,
              height: 10,
              //color: Colors.blueGrey.shade50,
            ),
            //padding: const EdgeInsets.all(15),
            //reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to delete this question ?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await q.Question.deleteQuestionFromOwner(
                                      data[index]);
                                  Navigator.of(context).pop();
                                  Provider.of<HomeProvider>(context,
                                          listen: false)
                                      .notify();
                                },
                                child: Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                  ),
                  QuestionComponent(data[index], false, false, _rebuild),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
