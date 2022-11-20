import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController? emailController = TextEditingController();
  GlobalKey<FormState> myFormKey = GlobalKey();
  bool scureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 10,
              title: Row(
                children: [
                  Image.asset(
                    "images/smallLogo.png",
                    height: constraints.maxHeight * 0.06,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "QCODE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            body: Form(
              key: myFormKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Forgot Password!",
                          style: TextStyle(
                            fontSize: constraints.maxHeight * .045,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                        Text(
                            "Enter your email and we'll send you a link to reset your password"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: ((value) {
                              // Check if this field is empty
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }

                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }

                              // the email is valid
                              return null;
                            }),
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 45, left: 45),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(constraints.maxHeight * 0.2,
                                  constraints.maxHeight * .06),
                              maximumSize: Size(constraints.maxHeight * 0.25,
                                  constraints.maxHeight * .07),
                            ),
                            onPressed: () async {
                              if (myFormKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: emailController!.text.trim());
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          content:
                                              Text("password reset link sent"),
                                        );
                                      }));
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          content: Text(e.message.toString()),
                                        );
                                      }));
                                }
                              }
                            },
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
