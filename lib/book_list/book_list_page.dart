import 'package:book_lisy_sample/add_book/add_book_page.dart';
import 'package:book_lisy_sample/book_list/book_list_model.dart';
import 'package:book_lisy_sample/domain/book.dart';
import 'package:book_lisy_sample/edit_book/edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                (book) => Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '編集',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () async {
                        final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book),
                              fullscreenDialog: true,
                            ));

                        //このaddedはadded == true のことを表している！！
                        if (title != null) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('$titleを編集しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        //ここでfirestoreに登録した情報が更新処理で画面に描画されるようにする。
                        model.fetchBookList();
                      },
                    ),
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {},
                    ),
                  ],
                ),
              )
              .toList();
          return ListView(
            children: widgets,
          );
        })),
        // floatingActionButtonもここでConsumerで括らないと、fetchBookListがmodelを参照できない！
        floatingActionButton: Consumer<BooKListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(),
                    fullscreenDialog: true,
                  ));

              //このaddedはadded == true のことを表している！！
              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              //ここでfirestoreに登録した情報が更新処理で画面に描画されるようにする。
              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
