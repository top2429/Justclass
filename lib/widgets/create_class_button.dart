import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/all_themes.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/create_class_form.dart';
import 'package:provider/provider.dart';

class CreateClassButton extends StatefulWidget {
  @override
  _CreateClassButtonState createState() => _CreateClassButtonState();
}

class _CreateClassButtonState extends State<CreateClassButton> {
  final data = NewClassData();
  bool isLoading = false;

  void addNewClass() async {
    try {
      setState(() => isLoading = true);
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      await Provider.of<ClassManager>(context, listen: false).add(uid, data);
    } catch (error) {
      AppSnackBar.show(context, message: error.toString(), bgColor: Colors.amberAccent);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showCreateClassDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: CreateClassForm(data, addNewClass),
        );
      },
    );
  }

  @override
  Widget build(BuildContext _) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const ratio = 25 / 20; // height / width
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;
        (height >= width * ratio) ? height = width * ratio : width = height / ratio;

        final btnHeight = height * 4 / 18;

        return Stack(
          children: <Widget>[
            Container(height: height, width: width),
            Positioned(
              width: width,
              child: Material(
                elevation: 8,
                shape: CircleBorder(),
                child: Image.asset('assets/images/teacher.png', fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: height * 0.72,
              height: btnHeight,
              width: width,
              child: MaterialButton(
                disabledColor: Colors.grey[100],
                disabledElevation: 10,
                height: btnHeight,
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btnHeight * 0.5),
                ),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    isLoading
                        ? const SpinKitDualRing(color: AllThemes.primaryColor, size: 15, lineWidth: 1.5)
                        : const Icon(Icons.add, color: AllThemes.primaryColor),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          isLoading ? 'Creating...' : 'Create class',
                          style: TextStyle(
                            color: AllThemes.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: btnHeight * 0.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                onPressed: isLoading ? null : showCreateClassDialog,
              ),
            ),
          ],
        );
      },
    );
  }
}
