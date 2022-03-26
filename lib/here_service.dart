import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HereService extends ChangeNotifier {
  final hereCollection = FirebaseFirestore.instance.collection('bucket');

  Future<QuerySnapshot> read(String uid) async {
    // 내 hereList 가져오기
    return hereCollection.where('uid', isEqualTo: uid).get();
  }

  void create(String job, String uid) async {
    // here 만들기

    await hereCollection.add({
      'uid': uid, // 유저 식별자
      'job': job, // 하고싶은 일
      'isDone': false, // 완료 여부
    });
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, bool isDone) async {
    // here isDone 업데이트

    await hereCollection.doc(docId).update({'isDone': isDone});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // here 삭제

    await hereCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}
