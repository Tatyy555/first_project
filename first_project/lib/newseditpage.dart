
import 'package:first_project/newslistpage.dart';
import 'package:flutter/material.dart';
// Firestoreと連携させるため以下追加。
import 'package:cloud_firestore/cloud_firestore.dart';
// Firebase authと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// hashtag機能を実装。
import 'package:material_tag_editor/tag_editor.dart';
import 'package:page_transition/page_transition.dart';
// constants.dart
import 'constants.dart';


// ニュース追加画面用のWidget。
class NewsEditPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  const NewsEditPage(this.user, this.document);

  // ユーザー情報
  final User user;
  final DocumentSnapshot document;

  @override
  _NewsEditPageState createState() => _NewsEditPageState();
}

class _NewsEditPageState extends State<NewsEditPage> {
  // 入力されたテキストをデータとして持つ。
  String url = '';
  String hash = '';
  String comment = '';

  // hashtag用の情報。
  final List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  
  TextEditingController _textEditingController2 =TextEditingController();
  TextEditingController _textEditingController3 =TextEditingController();
   

  @override
  void initState() {
    super.initState();
    _textEditingController2 = TextEditingController(text: widget.document['url']); 
    _textEditingController3 = TextEditingController(text: widget.document['comment']); 
  }

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
                    'ニュース編集',
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
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),  
                        ),
                        controller: _textEditingController2,
                        // initialValue: widget.document['url'], 
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
                        child:TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          controller: _textEditingController3,
                          // initialValue: widget.document['comment'] ,
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
                                '更新',
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
                                    .doc(widget.document.id) // ドキュメントIDを指定
                                    .update({
                                      'url': url,
                                      'hash': hash,
                                      'comment': comment,
                                      'email': email,
                                      'date': date
                                    });
                                await Navigator.of(context).pushReplacement(
                                  PageTransition(child:NewsListPage(widget.user), type: PageTransitionType.leftToRight)
                                );
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
