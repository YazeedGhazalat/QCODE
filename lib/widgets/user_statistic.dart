import 'package:flutter/material.dart';

class UserSatistic extends StatelessWidget {
  final int _questions,_solutions;
  UserSatistic(this._questions,this._solutions);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "$_questions",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  
            ),
            const Text(
              "Posts",
              style: TextStyle(
                //color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
          width: 10,
          child: VerticalDivider(
            //color: Colors.white,
            thickness: 1,
          ),
        ),
        Column(
          children: [
            Text(
              "$_solutions",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
            ),
            const Text(
              "Points",
              style: TextStyle(
                //color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
