import 'package:flutter/material.dart';
import 'package:first_project/newslistpage.dart';

// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Container(
              child: Image.asset('assets/images/logo2.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'News Logs',
              style: TextStyle(fontSize: 35, color: kBaseColor),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: kBaseColor,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 80,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'メールアドレス',
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'パスワード(6文字以上)',
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // パスワード入力
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      // パスワードが見えないようにする。
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      // メッセージ表示
                      child: Text(infoText),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        // 余白を均等に並べる。
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 130,
                            height: 60,
                            // ログイン登録ボタン
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  )),
                              child: const Text(
                                'ログイン',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kBaseColor),
                              ),
                              onPressed: () async {
                                // Firebaseと連携させるため以下追加。
                                try {
                                  // メール/パスワードでログイン
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  // ログインに成功した場合
                                  // チャット画面に遷移＋ログイン画面を破棄
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return NewsListPage(result.user!);
                                    }),
                                  );
                                } catch (e) {
                                  // ログインに失敗した場合
                                  setState(() {
                                    infoText = "ログインに失敗しました：${e.toString()}";
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 60,
                            // ユーザー登録ボタン
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  )),
                              child: const Text(
                                '新規登録',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kBaseColor),
                              ),
                              onPressed: () async {
                                // firebase Authと連携。
                                try {
                                  // メール/パスワードでユーザー登録
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  // ユーザー登録に成功した場合
                                  // チャット画面に遷移＋ログイン画面を破棄
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return NewsListPage(result.user!);
                                    }),
                                  );
                                } catch (e) {
                                  // ユーザー登録に失敗した場合
                                  setState(() {
                                    infoText = "登録に失敗しました：${e.toString()}";
                                  });
                                }
                              },
                            ),
                          ),
                        ])
                  ],
                ),
              ),
            ),
            // メールアドレス入力
          ],
        ),
      ),
    );
  }
}
