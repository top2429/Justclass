import 'package:flutter/material.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/utils/validators.dart';

class AboutClassArea extends StatelessWidget {
  final ClassDetailsData data;
  final ClassDetailsData input;
  final Function changeUpdateBtnState;

  AboutClassArea({this.data, this.input, this.changeUpdateBtnState});

  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(data.theme).primaryColor;

    final padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 20);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            'About',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: padding,
          child: TextFormField(
            initialValue: data.title,
            decoration: InputDecoration(
              labelText: 'Title',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (val) {
              input.title = val;
              changeUpdateBtnState(CreateClassValidator.validateClassTitle(val) == null);
            },
          ),
        ),
        Padding(
          padding: padding,
          child: TextFormField(
            initialValue: data.subject,
            decoration: InputDecoration(
              labelText: 'Subject',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (val) => input.subject = val,
          ),
        ),
        Padding(
          padding: padding,
          child: TextFormField(
            initialValue: data.section,
            decoration: InputDecoration(
              labelText: 'Section',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (val) => input.section = val,
          ),
        ),
        Padding(
          padding: padding,
          child: TextFormField(
            initialValue: data.room,
            decoration: InputDecoration(
              labelText: 'Room',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (val) => input.room = val,
          ),
        ),
        Padding(
          padding: padding,
          child: TextFormField(
            initialValue: data.description,
            decoration: InputDecoration(
              labelText: 'Description',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 5,
            onChanged: (val) => input.description = val,
          ),
        ),
      ],
    );
  }
}
