import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';
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
}
