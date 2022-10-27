import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stackexchange/widgets/Drawer.dart';
import '../widgets/question.dart';
import '../models/user.dart' as u;
import '../models/stack.dart' as s;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Home extends StatelessWidget {
  Home({super.key});
Future _getUserData() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Users").doc(userId).get();
  final u.User _user = u.User.getInstance();
  _user.userData = doc;
}
final s.Stack _stack = s.Stack.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                size: 30,
                FontAwesomeIcons.accusoft,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Stack",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Questions").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data!.docs;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search....",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) =>
                          QuestionComponent(data[index],false),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/add_new_question");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
