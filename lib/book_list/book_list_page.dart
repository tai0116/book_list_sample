import 'package:book_lisy_sample/book_list/book_list_model.dart';
import 'package:book_lisy_sample/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BooKListModel>(
      //最後に..fetchBookList()をやらないと、本一覧を取ってこれず、永遠にグルグルマークが出てきてしまう。
      create: (_) => (BooKListModel())..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),
        body: Center(child: Consumer<BooKListModel>(builder: (context, model, child) {
          final List<Book>? books = model.books;

          //fetchでデータを取ってきている間、bookがnullだったら、CircularProgressIndicator();が回り
          if (books == null) {
            return CircularProgressIndicator();
          }

          //上記が終わったら、booksがnullではないということなので、ListViewでの表示に進んでいく。
          //ListViewは、上記で書いたList<Book>?

          final List<Widget> widgets = books
              .map(
                (book) => ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                ),
              )
              .toList();
          return ListView(
            children: widgets,
          );
        })),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
