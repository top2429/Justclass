import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/create_class_form.dart';
import 'package:provider/provider.dart';

class CreateClassButton extends StatefulWidget {
  final Function onDidCreateClass;

  CreateClassButton({this.onDidCreateClass});

  @override
  _CreateClassButtonState createState() => _CreateClassButtonState();
}

class _CreateClassButtonState extends State<CreateClassButton> {
  var data = CreateClassFormData(theme: Themes.getRandomTheme());
  bool _isLoading = false;

  void addNewClass() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<ClassManager>(context, listen: false).add(data);
      widget.onDidCreateClass();
      data = CreateClassFormData(theme: Themes.getRandomTheme());
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showCreateClassDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
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
                shape: const CircleBorder(),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnHeight * 0.5)),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _isLoading
                        ? const SpinKitDualRing(color: Themes.primaryColor, size: 15, lineWidth: 1.5)
                        : const Icon(Icons.add, color: Themes.primaryColor),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          _isLoading ? 'Creating...' : 'Create class',
                          style: TextStyle(
                            color: Themes.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: btnHeight * 0.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                onPressed: _isLoading ? null : showCreateClassDialog,
              ),
            ),
          ],
        );
      },
    );
  }
}
