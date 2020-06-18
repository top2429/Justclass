import 'package:flutter/foundation.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/utils/api_call.dart';

class NoteManager extends ChangeNotifier {
  String cid;
  List<Note> notes;

  NoteManager({
    @required this.cid,
    @required this.notes,
  });

  Future<void> postNote(String uid, String content, Map<String, String> files) async {
    try {
      final newNote = await ApiCall.postNote(uid, cid, content, files);
      notes.insert(0, newNote);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeNote(String uid, String nid) async {
    final index = notes.indexWhere((n) => n.noteId == nid);
    final removedNote = notes.removeAt(index);
    notifyListeners();
    try {
      await ApiCall.removeNote(uid, nid);
    } catch (error) {
      notes.insert(index, removedNote);
      notifyListeners();
      throw (error);
    }
  }

  Future<void> updateNote(
    String uid,
    String nid,
    String content,
    List<String> deletedFileIds,
    Map<String, String> newFiles,
  ) async {
    try {
      final data = await ApiCall.updateNote(
        uid,
        nid,
        content: content,
        deletedFileIds: deletedFileIds,
        newFiles: newFiles,
      );

      final note = notes.firstWhere((n) => n.noteId == nid);

      note.setAttachments(data['attachments']);
      note.setContent(data['content']);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
