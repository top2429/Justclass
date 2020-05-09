import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/screens/class_screen.dart';
import 'package:justclass/widgets/remove_class_alert_dialog_owner.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'app_snack_bar.dart';

class ClassListViewTileOwner extends StatelessWidget {
  final BuildContext context;

  ClassListViewTileOwner({@required this.context});

  static const _radius = BorderRadius.all(Radius.circular(8));

  void _removeClass(String cid, String classTitle) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) => RemoveClassAlertDialogOwner(context: context, classTitle: classTitle),
      );
      result ??= false;
      if (result) await Provider.of<ClassManager>(context, listen: false).removeClass(cid);
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Consumer<Class>(
        builder: (_, cls, __) {
          final studentCount = cls.studentCount;
          final countStr = studentCount == 1 ? '$studentCount student' : '$studentCount students';

          return Stack(
            children: <Widget>[
              Container(
                height: 130,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: _radius,
                  child: Hero(
                    tag: 'background${cls.cid}',
                    child: Image.asset(Themes.forClass(cls.theme).imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  borderRadius: _radius,
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.black12,
                    borderRadius: _radius,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClassScreen(cls: cls)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: DefaultTextStyle.merge(
                              style: const TextStyle(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    cls.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    cls.subject,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Text(countStr, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            PopupMenuButton(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              offset: const Offset(0, 40),
                              itemBuilder: (_) => [
                                const PopupMenuItem(child: Text('Remove'), value: 'remove', height: 40),
                              ],
                              onSelected: (val) {
                                if (val == 'remove') _removeClass(cls.cid, cls.title);
                              },
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(bottom: 17),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: _radius),
        title: Text(
          'Are you sure?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade600),
        ),
//      content: const Text(
//        'All of the members and content of this class will be gone.',
//      ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'All of the members and content of this class will be gone.\nEnter your class title to proceed:',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: const InputDecoration(labelText: 'Class Title'),
                onChanged: (val) {},
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Yes',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade600),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          FlatButton(
            child: Text(
              'No',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
