import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:justclass/utils/test.dart';
import 'package:justclass/widgets/class_list_view.dart';
import 'package:justclass/widgets/create_class_form.dart';

class ClassManager with ChangeNotifier {
  List<Class> _classes = [];

  List<Class> get classes => [..._classes];

  Future<void> add(String uid, NewClassData data) async {
    try {
      final newClass = await ApiCall.createClass(uid, data);
      _classes.add(newClass);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchData() async {
    await Test.delay(1);
    _classes = testData;
    notifyListeners();
  }

  List<Class> getClasses(Filter type) {
    switch (type) {
      case Filter.ALL:
        return _classes;
      case Filter.CREATED:
        return _classes.where((c) => c.role == ClassRole.OWNER);
      case Filter.JOINED:
        return _classes.where((c) => c.role == ClassRole.STUDENT);
      case Filter.ASSISTING:
        return _classes.where((c) => c.role == ClassRole.ASSISTANT);
      default:
        return [];
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
