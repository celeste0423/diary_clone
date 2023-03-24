import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_pencake_clone/repository/notepage_repository.dart';

class Note {
  String? id;
  String? notePageid;
  final String? noteTitle;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Note({
    this.id,
    this.notePageid,
    required this.noteTitle,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_page_id': notePageid,
      'note_title': noteTitle,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  static Note fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] == null ? '' : json['id'] as String?,
        notePageid:
            json['note_page_id'] == null ? '' : json['note_page_id'] as String,
        noteTitle:
            json['note_title'] == null ? '' : json['note_title'] as String?,
        content: json['content'] == null ? '' : json['content'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : (json['created_at'] as Timestamp).toDate(),
        updatedAt: json['updatedAt'] == null
            ? null
            : (json['updatedAt'] as Timestamp).toDate(),
        deletedAt: json['deletedAt'] == null
            ? null
            : (json['deletedAt'] as Timestamp).toDate(),
      );

  //Create a new note document
  static Future<Note> add(Notepage notepage) async {
    try {
      final notesCollection =
          FirebaseFirestore.instance.collection('notes').doc();
      final note = Note(
        id: notesCollection.id,
        notePageid: notepage.id,
        noteTitle: '',
        content: '',
        createdAt: DateTime.now(),
      );
      await notesCollection.set(note.toJson());
      return note;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // create 는 아래와 같이 쓰는 게 정석이긴 하지만..
  // // Add a new note document
  // static Future<void> create(Note note) async {
  //   try {
  //     final CollectionReference notesCollection =
  //         FirebaseFirestore.instance.collection('notes');
  //     await notesCollection.add(note.toJson());
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  // Read all note documents
  // static Future<List<Note>> readAll() async {
  //   try {
  //     final CollectionReference notesCollection =
  //         FirebaseFirestore.instance.collection('notes');
  //     final QuerySnapshot querySnapshot =
  //         await notesCollection.orderBy("created_at", descending: true).get();
  //     return querySnapshot.docs
  //         .map((doc) => Note.fromJson(doc.data()))
  //         .toList();
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  // Update an existing note document
  static Future<void> update(Note note) async {
    try {
      final DocumentReference noteDocument =
          FirebaseFirestore.instance.collection('notes').doc(note.id);
      await noteDocument.update(note.toJson());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Delete a note document
  static Future<void> delete(String noteId) async {
    try {
      final DocumentReference noteDocument =
          FirebaseFirestore.instance.collection('notes').doc(noteId);
      await noteDocument.delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
