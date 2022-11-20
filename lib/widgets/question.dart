import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stackexchange/widgets/save_button.dart';

class QuestionComponent extends StatefulWidget {
  final QueryDocumentSnapshot _post;
  final bool _isProfile;
  final bool _isFromSaves;
  final Function _rebuild;
  QuestionComponent(
    this._post,
    this._isProfile,
    this._isFromSaves,
    this._rebuild,
  );

  @override
  State<QuestionComponent> createState() => _QuestionComponentState();
}

class _QuestionComponentState extends State<QuestionComponent> {
  bool _isNew(DateTime date) {
    final DateTime dateTime = DateTime.now();
    final diffirence = dateTime.difference(date);
    if (diffirence.inHours < 6) {
      return true;
    }
    return false;
  }

  String _getTime(String date) {
    String dif;
    final DateTime time = DateTime.now();
    final DateTime postTime = DateTime.parse(date);
    if (time.difference(postTime).inDays != 0) {
      dif = "${time.difference(postTime).inDays.toString()} days ago";
    } else if (time.difference(postTime).inHours != 0) {
      dif = "${time.difference(postTime).inHours.toString()} hours ago";
    } else if (time.difference(postTime).inMinutes != 0) {
      dif = "${time.difference(postTime).inMinutes.toString()} min ago";
    } else {
      dif = "${time.difference(postTime).inSeconds.toString()} sec ago";
    }
    return dif;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      //color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: widget._isProfile
                ? null
                : () {
                    Navigator.of(context).pushNamed('/profile',
                        arguments: widget._post['userId']);
                  },
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget._post['userFullName'].toString(),
            ),
            subtitle: Text(
              _getTime(widget._post['date'].toString()),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget._post['userImageUrl'],
              ),
            ),
            trailing: widget._post['solvedComment'] != "null"
                ? Chip(
                    backgroundColor: Colors.green.withOpacity(0.3),
                    label: Text(
                      "Solved",
                      style: TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  )
                : SizedBox(),
          ),
          SizedBox(
            height: 15,
          ),
          //title
          SelectableText(
            widget._post['questionTitle'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //subtitle
          SelectableText(
            widget._post['description'].toString().length > 300
                ? "${widget._post['description'].toString().substring(0, 300)}..."
                : widget._post['description'].toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 5,
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              Chip(
                
                label: Text(
                  widget._post['type'],
                  style:
                      TextStyle(fontSize: 15, color: Colors.blueGrey.shade300),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/FullPost", arguments: {
                    'question': widget._post,
                    'rebuild': widget._rebuild,
                    'questionOwnerId': widget._post['userId'].toString(),
                  });
                },
                child: Text(
                  "View details",
                  // style: TextStyle(
                  //   color: Color(0xff2f3b47),
                  // ),
                ),
              ),
              SaveButton(widget._post, widget._isFromSaves),
            ],
          ),
        ],
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //     color: Colors.grey.shade200,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       if (widget._post['solvedComment'] != "null")
    //         Chip(
    //           //padding: EdgeInsets.zero,
    //           label: Text(
    //             "Solved",
    //             style: TextStyle(
    //               fontSize: 10,
    //               color: Colors.white,
    //             ),
    //           ),
    //           backgroundColor: Colors.green,
    //         ),
    //       ListTile(
    //         dense: true,
    //         onTap: widget._isProfile
    //             ? null
    //             : () {
    //                 Navigator.of(context).pushNamed('/profile',
    //                     arguments: widget._post['userId']);
    //               },
    //         leading: CircleAvatar(
    //           backgroundImage: NetworkImage(
    //             widget._post['userImageUrl'],
    //           ),
    //         ),
    //         contentPadding: EdgeInsets.zero,
    //         title: Text(widget._post['userFullName'].toString()),
    //         subtitle: Text(widget._post['date'].toString().substring(0, 10)),
    //         trailing: FittedBox(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    // Chip(
    //   backgroundColor: Color(0xff),
    //   label: Text(
    //     widget._post['type'],
    //     style: TextStyle(fontSize: 15),
    //   ),
    // ),
    //               SizedBox(
    //                 width: 5,
    //               ),
    //               if (_isNew(DateTime.parse(widget._post['date'])))
    //                 const Chip(
    //                   label: Text(
    //                     "new",
    //                     style: TextStyle(color: Colors.white, fontSize: 15),
    //                   ),
    //                   backgroundColor: Color(0xFFFF1e1e),
    //                 ),
    //               SaveButton(widget._post, widget._isFromSaves),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Text(
    //         widget._post['questionTitle'],
    //         style: Theme.of(context).textTheme.bodyText1,
    //       ),
    //       Container(
    //         margin: EdgeInsets.symmetric(vertical: 15),
    //         child: Text(
    // widget._post['description'].toString().length > 200
    //     ? "${widget._post['description'].toString().substring(0, 200)}..."
    //     : widget._post['description'].toString(),
    //         ),
    //       ),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: ElevatedButton(
    //               onPressed: () {
    //                 Navigator.of(context)
    //                     .pushNamed("/CommentSheet", arguments: {
    //                   "id": widget._post.id,
    //                   "isComment": true,
    //                   "questionOwnerId": widget._post['userId'].toString(),
    //                   "questionTitle": widget._post['questionTitle']

    //                 });
    //               },
    //               child: Text("Write your solution"),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Align(
    //         alignment: Alignment.center,
    //         child: TextButton(
    // onPressed: () {
    //   Navigator.of(context).pushNamed("/FullPost", arguments: {
    //     'question': widget._post,
    //     'rebuild': widget._rebuild,
    //     'questionOwnerId': widget._post['userId'].toString(),
    //   });
    // },
    //           child: Text("See full post"),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
