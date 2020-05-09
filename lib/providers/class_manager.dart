import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:justclass/utils/test.dart';
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
      // TODO: insert class to class list
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

//  static final testData = [
//    Class(
//      cid: '0',
//      title: 'KTPM_1234 co title rat chi la dai do',
//      publicCode: '010ax31',
//      role: ClassRole.OWNER,
//      theme: 0,
//      studentCount: 12,
//      section: 'Môn: Kiến trúc phần mềm',
//    ),
//    Class(
//      cid: '2',
//      title: 'THCNTT3_100 co title ra chi la dai do',
//      publicCode: '010ax31',
//      role: ClassRole.STUDENT,
//      theme: 2,
//      ownerName: 'Hieu Pham',
//    ),
//    Class(
//      cid: '1',
//      title: 'PPHDH_1996 day la ',
//      publicCode: '010ax31',
//      role: ClassRole.COLLABORATOR,
//      theme: 1,
//      subject: 'Môn: Phương pháp học đại học, nhung chua du dau, phai dai hon nua',
//      ownerName: 'Minh Ngoc',
//    ),
//    Class(
//      cid: '3',
//      title: 'THCNTT3_100',
//      publicCode: '010ax31',
//      role: ClassRole.OWNER,
//      theme: 3,
//      studentCount: 1,
//      ownerName: 'Hieu Pham',
//    ),
//    Class(
//      cid: '4',
//      title: 'Because I\'m Batman',
//      publicCode: '010ax31',
//      role: ClassRole.STUDENT,
//      theme: 4,
//      ownerName: 'Bruce Wayne',
//    ),
//  ];
}
