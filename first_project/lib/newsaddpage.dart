import 'package:flutter/material.dart';
// Firestoreと連携させるため以下追加。
import 'package:cloud_firestore/cloud_firestore.dart';
// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// hashtag機能を実装。
import 'package:material_tag_editor/tag_editor.dart';
// constants.dart
import 'constants.dart';

// ニュース追加画面用のWidget。
class NewsAddPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  const NewsAddPage(this.user);
  // ユーザー情報
  final User user;

  @override
  _NewsAddPageState createState() => _NewsAddPageState();
}

class _NewsAddPageState extends State<NewsAddPage> {
  // 入力されたテキストをデータとして持つ。
  String url = '';
  String hash = '';
  String comment = '';

  // hashtag用の情報。
  final List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kMainColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Center(
                child:Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'ニュース登録',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kBaseColor,
                      fontSize: 30,
                    ),
                  ),
                ),
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
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'URL',
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            url = value;
                          });
                        }
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'ハッシュタグ',
                          style: TextStyle(
                              color: kAccentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      TagEditor(
                        length: _values.length,
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        delimiters: const [',', ' '],
                        hasAddButton: true,
                        resetTextOnSubmitted: true,
                        // This is set to grey just to illustrate the `textStyle` prop
                        textStyle: const TextStyle(color: Colors.grey),
                        onSubmitted: (outstandingValue) {
                          setState(() {
                            _values.add(outstandingValue);
                          });
                        },
                        inputDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onTagChanged: (newValue) {
                          setState(() {
                            _values.add(newValue);
                          });
                        },
                        tagBuilder: (context, index) => _Chip(
                          index: index,
                          label: _values[index],
                          onDeleted: _onDelete,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'コメント',
                          style: TextStyle(
                              color: kAccentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child:TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          maxLines: 10,
                          onChanged: (String value) {
                            setState(() {
                              comment = value;
                            });
                          }
                        ),
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
                            // 登録ボタン
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  )),
                              child: const Text(
                                '登録',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              onPressed: () async {
                                // 現在の日時
                                final date = DateTime.now()
                                    .toLocal()
                                    .toIso8601String();
                                // NewsAddPageのデータを参照
                                final email = widget.user.email;
                                // 登録用ドキュメント作成
                                await FirebaseFirestore.instance
                                    .collection('news') // コレクションID指定
                                    .doc() // ドキュメントID自動生成
                                    .set({
                                      'url': url,
                                      'hash': hash,
                                      'comment': comment,
                                      'email': email,
                                      'date': date
                                    });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 60,
                            // 破棄ボタン
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                )
                              ),
                              child: const Text(
                                '破棄',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                // 前の画面に戻るだけです（何もデータは渡さない。）
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]
                  )
                )
              )
            ],
          ),
        )
      );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
