import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/question.dart' as q;
import '../widgets/question_images.dart';

class CommentComponent extends StatefulWidget {
  final QueryDocumentSnapshot _comment;
  final bool questionOwner;
  final QueryDocumentSnapshot _question;
  final Function _rebuild;
  CommentComponent(
    this._comment,
    this.questionOwner,
    this._question,
    this._rebuild,
  );

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  String? _vote;
  bool _isExpaning = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(15),
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        //color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.questionOwner &&
                    widget._question['solvedComment'] == "null")
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        await q.Question.closeQuestionFromOwner(
                          widget._question,
                          widget._comment,
                        );
                        Navigator.of(context).pop();

                        widget._rebuild();
                      } catch (err) {}
                    },
                    child: Text("Is This the Solution ?"),
                  ),
                if (widget._question['solvedComment'] != null &&
                    widget._question['solvedComment'] == widget._comment.id)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Chip(
                      //padding: EdgeInsets.zero,
                      label: Text(
                        "Best solution",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    trailing: Icon(Icons.push_pin),
                  ),
                ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget._comment['userProfileImage']),
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Text(widget._comment['userFullName']),
                  subtitle:
                      Text(widget._comment['date'].toString().substring(0, 16)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    widget._comment['comment'],
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          height: 1.4,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (widget._comment['images'].length != 0)
                  Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: QuestionImages(widget._comment['images']),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2f3b47),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/CommentSheet',
                          arguments: {
                            "id": widget._comment.id,
                            "isComment": false,
                            "commentOwnerId": widget._comment['userId'],
                            "comment": widget._comment['comment'].toString(),
                          },
                        );
                      },
                      child: Text("reply"),
                    ),
                    //if (widget._comment['replies'] != null)
                    TextButton.icon(
                      icon: Icon(_isExpaning
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          _isExpaning = !_isExpaning;
                        });
                      },
                      label: Text("show replies"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpaning)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Replies")
                  .doc(widget._comment.id)
                  .collection("Replies")
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return Center(
                    child: Text("There is no replies"),
                  );
                }
                return Container(
                  color: Colors.blueGrey.shade50,
                  padding: EdgeInsets.all(15),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index]['userProfileImage']),
                            ),
                            contentPadding: EdgeInsets.zero,
                            title: Text(data[index]['userFullName']),
                            subtitle: Text(data[index]['date']
                                .toString()
                                .substring(0, 16)),
                          ),
                          Container(
                            child: Text(data[index]['comment']),
                          ),
                          if (data[index]['images'].length != 0)
                            Container(
                              height: 300,
                              //margin: EdgeInsets.symmetric(vertical: 10),
                              child: QuestionImages(data[index]['images']),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
