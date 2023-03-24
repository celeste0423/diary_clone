import 'package:cloud_firestore/cloud_firestore.dart';

class Notepage {
  String? id;
  String? pageTitle;
  String? pageSubtitle;
  DateTime? pageCreatedAt;

  Notepage({
    this.id,
    this.pageTitle,
    this.pageSubtitle,
    this.pageCreatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page_title': pageTitle,
      'page_subtitle': pageSubtitle,
      'page_created_at': pageCreatedAt,
    };
  }

  static Notepage fromJson(Map<String, dynamic> json) => Notepage(
        id: json['id'] == null ? '' : json['id'] as String?,
        pageTitle:
            json['page_title'] == null ? '' : json['page_title'] as String?,
        pageSubtitle: json['page_subtitle'] == null
            ? ''
            : json['page_subtitle'] as String?,
        pageCreatedAt: json['page_created_at'] == null
            ? null
            : (json['page_created_at'] as Timestamp).toDate(),
      );

  static Future<Notepage> create() async {
    try{
      final notepageCollection =
          FirebaseFirestore.instance.collection('notepages').doc();
      final notepage = Notepage(
        id: notepageCollection.id,
        pageTitle: '',
        pageSubtitle: '',
        pageCreatedAt: DateTime.now(),
      );
      await notepageCollection.set(notepage.toJson());
      return notepage;
    } catch(e){
      print(e.toString());
      rethrow;
    }
  }

  static Future<void> update(Notepage notepage) async{
    try{
      final DocumentReference pageDocument =
          FirebaseFirestore.instance.collection('notepages').doc(notepage.id);
      await pageDocument.update(notepage.toJson());
    } catch(e){
      print(e.toString());
      rethrow;
    }
  }

  static Future<void> delete(String notepageId) async {
    try {
      final DocumentReference noteDocument =
      FirebaseFirestore.instance.collection('notepages').doc(notepageId);
      await noteDocument.delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
