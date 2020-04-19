import 'package:flutter/material.dart';
import 'package:justclass/widgets/join_class_form.dart';

class JoinClassButton extends StatelessWidget {
  void _showJoinClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: JoinClassForm(),
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
            Container(
              height: height,
              width: width,
            ),
            Positioned(
              width: width,
              child: Material(
                elevation: 5,
                color: Colors.transparent,
                shape: CircleBorder(),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btnHeight * 0.5),
                ),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.blue.shade900),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Join class',
                          style: TextStyle(
                            color: Colors.blue.shade900,
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
