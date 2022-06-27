import 'package:flutter/material.dart';


// Firestoreと連携させるため以下追加。


// ニュース追加画面用のWidget。
class NewsAddPage extends StatefulWidget{
  const NewsAddPage({Key? key}) : super(key: key);
  @override
  _NewsAddPageState createState() => _NewsAddPageState();
}

class _NewsAddPageState extends State<NewsAddPage>{
  // 入力されたテキストをデータとして持つ。
  String url = '';
  String hash = ''; 
  String comment = '';  
  
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child:Column(
          children: <Widget>[
            Expanded(
              flex: 2, // 割合.
              child:TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'URL',
                  labelText: 'URL',
                ),
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    url = value;
                  });
                }
              ),
            ),
            Expanded(
              flex: 2, // 割合.
              child:TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ハッシュタグ',
                  labelText: 'ハッシュタグ',
                ),
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    hash = value;
                  });
                }
              ),
            ),
            Expanded(
              flex: 4, // 割合.
              child:TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'コメント',
                  labelText: 'コメント',
                ),
                maxLines: 10,
                onChanged: (String value) {
                  setState(() {
                    comment = value;
                  });
                }
              ),
            ),
            Expanded(
              flex: 2, // 割合.
              child: Row(
                // 余白を均等に並べる。
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  SizedBox(
                    width: 130,
                    // 登録ボタン
                    child: ElevatedButton(
                      child: const Text('登録'),
                      onPressed: () async {
                        // 前の画面に戻るだけです（何もデータは渡さない。）
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    // 破棄ボタン
                    child: ElevatedButton(
                      child: const Text('破棄'),
                      onPressed: () async {
                        // 前の画面に戻るだけです（何もデータは渡さない。）
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ]
              ),
            ),
          ]
        )
      )
    );
  }
}


//       body: Container(
//         // 余白をつける。
//         padding: const EdgeInsets.all(40),
//         // 縦に並べる。
//         child: Column(
//           // 真ん中に配置する。
//           mainAxisAlignment: MainAxisAlignment.center,
          
//           children: <Widget>[
//             // テキストを表示。
//             Text(_text),
//             // テキストを入力できるBox作成。入力された値は_textに格納する。
//             TextField(
//               onChanged: (String value){
//                 setState((){
//                   _text = value;
//                 });
//               }
//             ),
//             // 追加ボタンの作成。
//             SizedBox(
//               // 横幅いっぱいに広げる。
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // _textを前の画面に渡す。
//                   Navigator.of(context).pop(_text);
//                 },
//                 child: const Text('リスト追加'),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () {
//                   // 前の画面に戻るだけ（何もデータは渡さない。）
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('キャンセル'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
