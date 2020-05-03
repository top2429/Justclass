import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:justclass/utils/mime_type.dart';
import 'package:justclass/utils/validator.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/loading_dual_ring.dart';
import 'package:mime/mime.dart';

import '../themes.dart';

class NewNoteScreenTeacher extends StatefulWidget {
  final ClassTheme theme;
  final String uid;
  final String cid;

  const NewNoteScreenTeacher({this.theme, this.cid, this.uid});

  @override
  _NewNoteScreenTeacherState createState() => _NewNoteScreenTeacherState();
}

class _NewNoteScreenTeacherState extends State<NewNoteScreenTeacher> {
  bool _valid = false;
  Map<String, String> _files = {};
  OverlayEntry _loadingSpin;

  @override
  void initState() {
    _loadingSpin = OverlayEntry(builder: (_) => LoadingDualRing());

    super.initState();
  }

  void _pickFiles(BuildContext context) async {
    FocusScope.of(context).unfocus();
    FilePicker.clearTemporaryFiles();
    Overlay.of(context).insert(_loadingSpin);

    try {
      final files = await FilePicker.getMultiFilePath(type: FileType.any);
      if (files != null) _files.addAll(files);
    } catch (error) {
      AppSnackBar.showError(context, message: "Unable to attach files!");
    } finally {
      _loadingSpin?.remove();
    }
    setState(() {});
  }

  void _sendNote(BuildContext context) async {
    FocusScope.of(context).unfocus();
    Overlay.of(context).insert(_loadingSpin);

    try {
      // TODO: call api from note manager
      await Future.delayed(const Duration(seconds: 5));
      throw HttpException();
      Navigator.of(context).pop();
    } catch (error) {
      AppSnackBar.showError(context, message: "Unable to post notes!");
    } finally {
      _loadingSpin?.remove();
    }
  }

  void _removeFile(String key) {
    _files.remove(key);
    setState(() {});
  }

  Future<bool> _onWillPopScope() async {
    _loadingSpin.remove();
    _loadingSpin = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildNoteInput(),
              Divider(),
              if (_files.isNotEmpty) ..._buildFileList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.theme.primaryColor,
      leading: AppIconButton(
        tooltip: 'Cancel',
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        Builder(builder: (context) {
          return AppIconButton(
            icon: const Icon(Icons.attachment),
            tooltip: 'Attachment',
            onPressed: () => _pickFiles(context),
          );
        }),
        Builder(builder: (context) {
          return AppIconButton(
            icon: const Icon(Icons.send),
            tooltip: 'Post',
            onPressed: !_valid ? null : () => _sendNote(context),
          );
        }),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(labelText: 'Share with your class'),
        onChanged: (val) {
          setState(() => _valid = NewNoteValidator.validateNote(val) == null);
        },
      ),
    );
  }

  List<Widget> _buildFileList() {
    final iconMap = _files.map((key, val) => MapEntry(key, MimeType.toIcon(lookupMimeType(val))));

    return iconMap.keys
        .map((key) => Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(iconMap[key], size: 30, color: widget.theme.primaryColor),
                  ),
                  Expanded(child: Text(key)),
                  AppIconButton.clear(
                    icon: const Icon(Icons.clear, color: Colors.black54, size: 20),
                    onPressed: () => _removeFile(key),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
