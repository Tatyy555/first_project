import 'package:flutter/material.dart';
import 'package:first_project/loginpage.dart';

// Firebaseと連携させるため以下追加。
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Firestoreと連携させるため以下追加。

// Firebaseと連携されるたmain()を以下の通り修正。
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FirstProject());
}




class FirstProject extends StatelessWidget {
  const FirstProject({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示されるDebugラベルを消す。
      debugShowCheckedModeBanner: false,
      // アプリ名をつける。
      title: 'First Project',
      // テーマを設定する。
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // LoginPageを表示する。
      home: const LoginPage(),
    );
  }
}