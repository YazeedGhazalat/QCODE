import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stackexchange/models/home_provider.dart';
import '../widgets/question.dart';
import '../models/question.dart' as q;

class MySaves extends StatefulWidget {
  MySaves({super.key});

  @override
  State<MySaves> createState() => _MySavesState();
}

class _MySavesState extends State<MySaves> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Saves"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Saves")
            .doc(uid)
            .collection("Saves")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("You didn't save any post"));
          }
          final data = snapshot.hasData ? snapshot.data!.docs : [];
          return ListView.separated(
            //padding: const EdgeInsets.all(15),
            separatorBuilder: (context, index) => Divider(
              thickness: 10,
              height: 10,
              //color: Colors.blueGrey.shade50,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return QuestionComponent(data[index], false, true, _rebuild);
            },
          );
        },
      ),
    );
  }
}
