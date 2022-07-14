// Material Components widgetsを利用。
import 'package:flutter/material.dart';
// 他ファイルのプログラムを利用。
import 'package:first_project/model/item_model.dart';
import 'package:first_project/repository/auth_repository.dart';
import 'package:first_project/view/item_list_page.dart';
import 'package:first_project/view_model/item_list_view_model.dart';
import 'package:first_project/constants.dart';
// Firebaseと連携させるため以下追加。
import 'package:firebase_auth/firebase_auth.dart';
// 状態管理を追加。
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
/// 左から終えるように変更。
import 'package:page_transition/page_transition.dart';

// ニュース追加画面用のWidget。
class NewsAddPage extends HookConsumerWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => NewsAddPage(item: item),
    );
  }
  final Item item;
  const NewsAddPage({Key? key, required this.item}) : super(key: key);
  // 追加 or 更新 の判定を行う
  bool get isUpdating => item.id != null;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final User user = ref.watch(userProvider)!; 
    // 初期値にタイトルを入れておく
    final urltextController = useTextEditingController(text: item.url);
    final commenttextController = useTextEditingController(text: item.comment);
    final emailtextController = useTextEditingController(text: user.email);
    final hashtextController = useTextEditingController(text: item.hash);
    // provider（状態の操作）
    final itemListNotifier = ref.watch(itemListProvider.notifier);
    return  Scaffold(
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
                  TextField(
                    controller: urltextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 1,
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
                    
                    // ハッシュタグ用。
                    // TagEditor(
                    //   length: _values.length,
                    //   controller: _textEditingController,
                    //   focusNode: _focusNode,
                    //   delimiters: const [',', ' '],
                    //   hasAddButton: true,
                    //   resetTextOnSubmitted: true,
                    //   // This is set to grey just to illustrate the `textStyle` prop
                    //   textStyle: const TextStyle(color: Colors.grey),
                    //   onSubmitted: (outstandingValue) {
                    //     setState(() {
                    //       _values.add(outstandingValue);
                    //     });
                    //   },
                    //   inputDecoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //   ),
                    //   onTagChanged: (newValue) {
                    //     setState(() {
                    //       _values.add(newValue);
                    //     });
                    //   },
                    //   tagBuilder: (context, index) => _Chip(
                    //     index: index,
                    //     label: _values[index],
                    //     onDeleted: _onDelete,
                    //   ),
                    // ),

                  TextField(
                    controller: hashtextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 1,
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
                      controller: commenttextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      maxLines: 10,
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
                            primary: isUpdating ? Colors.green : kMainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70),
                            )
                          ),
                          onPressed: () {
                            isUpdating ? itemListNotifier.updateItem(
                              // データの更新
                              updatedItem: item.copyWith(
                                url: urltextController.text.trim(),
                                comment: commenttextController.text.trim(),
                                email: emailtextController.text.trim(), 
                                hash: hashtextController.text.trim(),
                              ),
                            ) : itemListNotifier.addItem(
                              // データの追加
                              url: urltextController.text.trim(),
                              comment:commenttextController.text.trim(),
                              email: emailtextController.text.trim(), 
                              hash: hashtextController.text.trim(),
                            );
                            Navigator.of(context).pushReplacement(
                              PageTransition(child:const ItemListPage(), type: PageTransitionType.leftToRight)
                            );
                          },
                          child: Text(isUpdating ? '更新' : '追加',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kBaseColor
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ])
              )
            )
          ],
        ),
      )
    );
  }
}

