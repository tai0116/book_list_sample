import 'package:book_lisy_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBookModel extends ChangeNotifier {
  final Book book;

  //EditBookModelを最初にイニシャライズした時にできる処理を{}の中に書ける。
  EditBookModel(this.book) {
    titleController.text = book.title;
    authorController.text = book.author;
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? title;
  String? author;

  void setTitle(String title) {
    //このthis.titleは、上のString? title;を指している。
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  //このように記述すると、このisUpdated()は、どっちもnullの時は、trueを返し、どちらか一方でも入っていたら、falseを返すという意味になる。
  bool isUpdated() {
    return title != null || author != null;
  }

  //Future型はtry catchができる
  Future update() async {
    this.title = titleController.text;
    this.author = authorController.text;

    //firestoreに追加
    await FirebaseFirestore.instance.collection('books').doc(book.id).update({
      'title': title,
      'author': author,
    });
  }
}
