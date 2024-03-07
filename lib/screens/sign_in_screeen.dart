import 'package:amazon_app/resources/authentication_resources.dart';
import 'package:amazon_app/screens/sign_up_screen.dart';
import 'package:amazon_app/utils/color_theme.dart';
import 'package:amazon_app/utils/constants.dart';
import 'package:amazon_app/utils/utils.dart';
import 'package:amazon_app/widgets/button_widget.dart';
import 'package:amazon_app/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    amazonLogo,
                    height: screenSize.height * 0.10,
                  ),
                  Container(
                    height: screenSize.height * 0.6,
                    padding: const EdgeInsets.all(25),
                    width: screenSize.width * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign-In",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 33),
                        ),
                        TextFieldWidget(
                            hintText: "Enter your email",
                            title: "Email",
                            controller: emailController,
                            obscureText: false),
                        TextFieldWidget(
                            hintText: "Enter your password",
                            title: "Password",
                            controller: passwordController,
                            obscureText: true),
                        Align(
                          alignment: Alignment.center,
                          child: CustomMainButton(
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  letterSpacing: 0.6, color: Colors.black),
                            ),

                            color: yellowColor,
                            isLoading: isLoading,
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              String output =
                                  await authenticationMethods.signInUser(
                                      email: emailController.text,
                                      password: passwordController.text);
                              setState(() {
                                isLoading=false;
                              });
                              if (output == "success") {
                              } else {
                                Utils().flutterToast(output);
                              }
                            },

                            ),
                          ),

                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "New to Amazon?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  CustomMainButton(
                    child: const Text(
                      "Create an Amazon Account",
                      style:
                      TextStyle(letterSpacing: 0.6, color: Colors.black),
                    ),
                      color: Colors.grey[400]!,
                      isLoading: false,
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
