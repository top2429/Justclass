import 'package:flutter/foundation.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/utils/api_call.dart';

class NoteManager extends ChangeNotifier {
  List<Note> notes;

  NoteManager(this.notes);

  Future<void> postNote(String uid, String cid, String content, Map<String, String> files) async {
    try {
      await ApiCall.postNote(uid, cid, content, files);
    } catch (error) {
      throw error;
    }
  }
}
