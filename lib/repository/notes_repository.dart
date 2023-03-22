import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  final String? noteTitle;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Note({
    this.id,
    required this.noteTitle,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'note_title' : noteTitle,
      'content' : content,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
      'deleted_at' : deletedAt,
    };
  }

  static Note fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] == null ? '' : json['id'] as String?,
    noteTitle: json['note_title'] == null ? '' : json['note_title'] as String?,
    content: json['content'] == null ? '' : json['content'] as String,
    createdAt: json['created_at'] == null
        ? null
        : (json['created_at'] as Timestamp).toDate(),
    // createdAt: json['createdAt'] == null
    //     ? DateTime.now()
    //     : json['createdAt'].toDate(),
    updatedAt: json['updatedAt'] == null
        ? DateTime.now()
        : json['updatedAt'].toDate(),
    deletedAt: json['deletedAt'] == null ? null : json['deletedAt'].toDate(),
  );
}
