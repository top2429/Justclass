import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:justclass/widgets/class_list_view.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ClassManager with ChangeNotifier {
  List<Class> _classes = [];

  String _uid;

  set uid(String uid) => _uid = uid;

  List<Class> get classes => [..._classes];

  List<Class> getClassesOnViewType(ViewType type) {
    switch (type) {
      case ViewType.ALL:
        return _classes;
      case ViewType.CREATED:
        return _classes.where((c) => c.role == ClassRole.OWNER).toList();
      case ViewType.JOINED:
        return _classes.where((c) => c.role == ClassRole.STUDENT).toList();
      case ViewType.COLLABORATING:
        return _classes.where((c) => c.role == ClassRole.COLLABORATOR).toList();
      default:
        return [];
    }
  }

  Class getClass(String cid) => _classes.firstWhere((cls) => cls.cid == cid, orElse: () => null);

  Future<void> add(CreateClassFormData data) async {
    try {
      final newClass = await ApiCall.createClass(_uid, data);
      _classes.insert(0, newClass);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchClassList() async {
    try {
      _classes = await ApiCall.fetchClassList(_uid);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> joinClass(String publicCode) async {
    try {
      final cls = await ApiCall.joinClassWithCode(_uid, publicCode);
      _classes.insert(0, cls);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeClass(String cid) async {
    // optimistic pattern
    final index = _classes.indexWhere((cls) => cls.cid == cid);
    final cls = _classes.removeAt(index);
    notifyListeners();
    try {
      await ApiCall.removeOwnedClass(_uid, cid);
    } catch (error) {
      _classes.insert(index, cls);
      notifyListeners();
      throw error;
    }
  }

  Future<void> leaveClass(String cid) async {
    // optimistic pattern
    final index = _classes.indexWhere((cls) => cls.cid == cid);
    final cls = _classes.removeAt(index);
    notifyListeners();
    try {
      await ApiCall.leaveCLass(_uid, cid);
    } catch (error) {
      _classes.insert(index, cls);
      notifyListeners();
      throw error;
    }
  }
}
