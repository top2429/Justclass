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
      case ViewType.ASSISTING:
        return _classes.where((c) => c.role == ClassRole.ASSISTANT).toList();
      default:
        return [];
    }
  }

  Future<void> add(CreateClassFormData data) async {
    try {
      final newClass = await ApiCall.createClass(_uid, data);
      _classes.insert(0, newClass);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchData() async {
    try {
      _classes = await ApiCall.fetchClassList(_uid);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  static final testData = [
    Class(
      cid: '0',
      title: 'KTPM_1234',
      publicCode: '010ax31',
      role: ClassRole.OWNER,
      theme: 0,
      studentCount: 12,
      section: 'Môn: Kiến trúc phần mềm',
    ),
    Class(
      cid: '2',
      title: 'THCNTT3_100',
      publicCode: '010ax31',
      role: ClassRole.STUDENT,
      theme: 2,
      ownerName: 'Hieu Pham',
    ),
    Class(
      cid: '1',
      title: 'PPHDH_1996 day la test text input qua dai',
      publicCode: '010ax31',
      role: ClassRole.ASSISTANT,
      theme: 1,
      section: 'Môn: Phương pháp học đại học, nhung chua du dau, phai dai hon nua',
      ownerName: 'Minh Ngoc',
    ),
    Class(
      cid: '3',
      title: 'THCNTT3_100',
      publicCode: '010ax31',
      role: ClassRole.OWNER,
      theme: 3,
      studentCount: 1,
      ownerName: 'Hieu Pham',
    ),
    Class(
      cid: '4',
      title: 'Because I\'m Batman',
      publicCode: '010ax31',
      role: ClassRole.STUDENT,
      theme: 4,
      ownerName: 'Bruce Wayne',
    ),
  ];
}
