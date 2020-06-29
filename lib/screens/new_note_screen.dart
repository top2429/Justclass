import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/note_manager.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/utils/mime_type.dart';
import 'package:justclass/utils/validators.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';
import 'package:mime/mime.dart';

import '../themes.dart';

class NewNoteScreen extends StatefulWidget {
  static const routeName = 'new-note-screen-teacher';

  final NoteManager noteMgr;
  final ClassTheme theme;
  final String uid;
  final String cid;

  NewNoteScreen({@required this.noteMgr, this.theme, this.cid, this.uid});

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  BuildContext screenCtx;

  // a flag indicating if the form is valid
  bool _valid = false;

  // a flag showing that whether request is sending or not
  bool _loading = false;

  // a map of <file name, file path>
  Map<String, String> _files = {};

  // storing the user input
  String content;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AppContext.add(screenCtx, '${NewNoteScreen.routeName} ${widget.cid}'));
    super.initState();
  }

  @override
  void dispose() {
    AppContext.pop();
    super.dispose();
  }

  void _pickFiles(BuildContext context) async {
    setState(() => _loading = true);
    try {
      final files = await FilePicker.getMultiFilePath(type: FileType.any);
      if (files != null) {
        _files.addAll(files);
        setState(() {});
      }
    } catch (error) {
      AppSnackBar.showError(screenCtx, message: "Unable to attach files!");
    } finally {
      _hideLoadingSpin();
    }
  }

  void _postNote(BuildContext context) async {
    _showLoadingSpin();
    try {
      await widget.noteMgr.postNote(widget.uid, content, _files);
      FilePicker.clearTemporaryFiles();
      if (this.mounted) Navigator.of(context).pop();
      AppSnackBar.showSuccess(screenCtx,
          message: 'Your note has been posted.', delay: const Duration(milliseconds: 400));
    } catch (error) {
      AppSnackBar.showError(screenCtx, message: error.toString());
    } finally {
      _hideLoadingSpin();
    }
  }

  void _showLoadingSpin() {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
  }

  void _hideLoadingSpin() {
    if (this.mounted) setState(() => _loading = false);
  }

  void _removeFile(String key) {
    _files.remove(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: widget.theme.primaryColor,
        appBar: _buildAppBar(),
        body: LayoutBuilder(builder: (context, constraints) {
          screenCtx = context;
          final bottom = MediaQuery.of(context).viewInsets.bottom;
          return SafeArea(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                color: Colors.white,
                height: constraints.maxHeight,
                alignment: Alignment.topCenter,
                child: Container(
                  height: constraints.maxHeight - bottom,
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          _buildNoteInput(),
                          Divider(),
                          if (_files.isNotEmpty) ..._buildFileList(),
                        ],
                      ),
                      Visibility(visible: _loading, child: OpaqueProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: widget.theme.primaryColor,
      leading: AppIconButton.cancel(onPressed: () => Navigator.of(context).pop()),
      actions: <Widget>[
        AppIconButton(
          icon: const Icon(Icons.attachment),
          tooltip: 'Attachment',
          onPressed: _loading ? null : () => _pickFiles(context),
        ),
        AppIconButton(
          icon: const Icon(Icons.send),
          tooltip: 'Post',
          onPressed: (!_valid || _loading) ? null : () => _postNote(context),
        ),
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
          content = val;
          setState(() => _valid = NewNoteValidator.validateNote(val) == null);
        },
      ),
    );
  }

  List<Widget> _buildFileList() {
    final iconMap = _files.map((name, path) => MapEntry(name, MimeType.toIcon(lookupMimeType(path))));

    return iconMap.keys
        .map((key) => Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(iconMap[key], size: 30, color: widget.theme.primaryColor),
                  ),
                  Expanded(child: Text(key, overflow: TextOverflow.ellipsis)),
                  AppIconButton.cancel(
                    icon: const Icon(Icons.clear, color: Colors.black54, size: 20),
                    onPressed: () => _removeFile(key),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
