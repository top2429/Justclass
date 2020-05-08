import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/join_class_form.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class JoinClassButton extends StatefulWidget {
  final Function onDidJoinClass;

  JoinClassButton({this.onDidJoinClass});

  @override
  _JoinClassButtonState createState() => _JoinClassButtonState();
}

class _JoinClassButtonState extends State<JoinClassButton> {
  bool _isLoading = false;

  Future<void> joinClass(String publicCode) async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<ClassManager>(context, listen: false).joinClass(publicCode);
      widget.onDidJoinClass();
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showJoinClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: JoinClassForm(onJoinClass: joinClass),
        );
      },
    );
  }

  @override
  Widget build(BuildContext _) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const ratio = 25 / 20; // height-width ratio
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
                elevation: 5,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: Image.asset('assets/images/student.png', fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: height * 0.72,
              height: btnHeight,
              width: width,
              child: MaterialButton(
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
                          _isLoading ? 'Joining...' : 'Join class',
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
                onPressed: () => this._showJoinClassDialog(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
