import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Facebook Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () async {
              final LoginResult result = await FacebookAuth.instance.login(
                  permissions: [
                    "public_profile",
                    "email"
                  ]); // by default we request the email and the public profile

              if (result.status == LoginStatus.success) {
                final AccessToken accessToken = result.accessToken;

                // Create a credential from the access token
                final facebookAuthCredential =
                    FacebookAuthProvider.credential(accessToken.token);

                // Once signed in, return the UserCredential
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithCredential(facebookAuthCredential);
                print(userCredential.user.email);
              }
            },
            icon: Image.asset("assets/icon.png"),
            label: Text('Facebook Login'),
          ),
        ));
  }
}
