import 'package:flutter/material.dart';
import 'package:justclass/widgets/create_class_form.dart';

class CreateClassButton extends StatefulWidget {
  @override
  _CreateClassButtonState createState() => _CreateClassButtonState();
}

class _CreateClassButtonState extends State<CreateClassButton> {
  final data = NewClassData();

  void _showCreateClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: CreateClassForm(data),
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
                          'Create class',
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
                onPressed: () => _showCreateClassDialog(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
