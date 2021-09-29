import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.name, this.description) {
    nameController.text = name!;
    descriptionController.text = description!;
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? name;
  String? description;

  void setName(String name) {
    //このthis.titleは、上のString? title;を指している。
    this.name = name;
    notifyListeners();
  }

  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  //このように記述すると、このisUpdated()は、どっちもnullの時は、trueを返し、どちらか一方でも入っていたら、falseを返すという意味になる。
  bool isUpdated() {
    return name != null || description != null;
  }

  //Future型はtry catchができる
  Future update() async {
    this.name = nameController.text;
    this.description = descriptionController.text;

    //firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'description': description,
    });
  }
}
