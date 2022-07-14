// Material Components widgetsを利用。
import 'package:flutter/material.dart';
// 他ファイルのプログラムを利用。
import 'package:first_project/view/login_page.dart';
// Firebaseと連携させるため以下追加。
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// 状態管理を追加。
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Firebaseと連携されるたmain()を以下の通り修正。
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 状態管理(hooks_riverpod)を利用するために修正。
  runApp(const ProviderScope(child: FirstProject()));
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
      home: LoginPage(),
    );
  }
}