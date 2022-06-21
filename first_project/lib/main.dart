import 'package:flutter/material.dart';
import 'package:first_project/loginpage.dart';



void main() {
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