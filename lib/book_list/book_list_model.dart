import 'package:book_lisy_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  //ここに書いておいた方が色々な場所で使い回しができるけど、下記のようにfinal QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('books').get();と書いた方がシンプル。
  //final _userCollection = FirebaseFirestore.instance.collection('books');

  //【streamを使った時のコード↓】
  //collectionの中身である「book」が変化したら発火するコードをここで定義している。こstreamってやつは多分リアルタイムの変更を通知するものだと思われる。
  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('books').snapshots();

  //List<Book>? books; の意味は、変数bookにはList<Book>という型か、？（null）が入りえるという意味。
  // fetchBookistが終わっていない時は、nullになり、
  List<Book>? books; //④

  void fetchBookList() async {
    //このgetで、ホバーすると、このgetはFuture型のQuerySnapshotなので、このsnapshotという変数の中にQuerySnapshotが入る。
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('books').get();
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      //とりあえず右辺のdocument型のdataを左辺のstring型のdataにする（①）
      Map<String, dynamic> data = document.data() as Map<String, dynamic>; //①
      //firebaseで勝手に生成されるidは、documentの中に入っているので、documentにドット演算子で生やすことができる。
      final String id = document.id;
      final String title = data['title']; //②
      final String author = data['author']; //③

      return Book(id, title, author); //←この1行にまさに集約されている！！！returnとして返したいのは、自前で用意した
      //class Book {
      //   Book(this.title, this.author);
      //   String title;
      //   String author;
      // }
      //この形にデータを保存すること！！
      //①でfirebaseに入っている箱をbooksという変数に格納。firebaseに入っているデータをtitleとauthorという変数にする（②と③）これによって、自前で作ったクラスにデータを保管できる。
    }).toList();

    //【streamを使った時のコード↓】
    //上記で定義したstreamを実際に使用するための関数
    //何かしらの変化があると、このlistenの中のsnapshotのなかに入ってくる。
    //_usersStream.listen((QuerySnapshot snapshot) {
    //domainパッケージの中に作ったbookという配列にしたい。

    //this.booksって書くと④にbooksが入る。
    this.books = books;
    //それをQEDみたいな感じで、証明終了的な感じでnotifyListeners();してあげるとviewの方のconsumerが発火する！！
    notifyListeners();
  }

  Future delete(Book book) {
    return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}
