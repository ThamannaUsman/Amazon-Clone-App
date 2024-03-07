import 'package:amazon_app/layout/screen_layout.dart';
import 'package:amazon_app/providers/user_details_provider.dart';

import 'package:amazon_app/screens/sign_in_screeen.dart';
import 'package:amazon_app/utils/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDH4U0j8hUKA1yMW-CbkoENSTq9eAUsF5g",
            authDomain: "app-ee74c.firebaseapp.com",
            projectId: "app-ee74c",
            storageBucket: "app-ee74c.appspot.com",
            messagingSenderId: "1071293100040",
            appId: "1:1071293100040:web:e4b14a1392f5a1bccd61bd",
            measurementId: "G-BW5W2Y8R30"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const AmazonClone());
}

class AmazonClone extends StatelessWidget {
  const AmazonClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserDetailsProvider())],
      child: MaterialApp(
        title: "Amazon Clone",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> user) {
            if (user.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            } else if (user.hasData) {
              return const ScreenLayout();
            } else {
              return const SignInScreen();
            }
          },
        ),
        // home: const ScreenLayout(),
      ),
    );
  }
}
