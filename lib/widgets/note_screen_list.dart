import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/note_manager.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'app_snack_bar.dart';
import 'note_screen_top_bar.dart';

class NoteScreenList extends StatefulWidget {
  @override
  _NoteScreenListState createState() => _NoteScreenListState();
}

class _NoteScreenListState extends State<NoteScreenList> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  bool hasError = false;
  bool didFirstLoad = false;

  Future<void> fetchNotesFirstLoad(Class cls) async {
    try {
      await cls.fetchNoteList();
      setState(() => didFirstLoad = true);
    } catch (error) {
      if (this.mounted) {
        AppSnackBar.showError(context, message: error.toString());
        setState(() {
          didFirstLoad = true;
          hasError = true;
        });
      }
    }
  }

  Future<void> fetchNotes(Class cls) async {
    try {
      await cls.fetchNoteList();
      setState(() => hasError = false);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cls = Provider.of<Class>(context);
    final noteMgr = Provider.of<NoteManager>(context);
    final color = Themes.forClass(cls.theme).primaryColor;

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        color: color,
        onRefresh: () => fetchNotes(cls),
        displacement: 63,
        child: CustomScrollView(
          slivers: <Widget>[
            NoteScreenTopBar(),
            Builder(
              builder: (context) {
                if (!didFirstLoad && noteMgr.notes == null) {
                  fetchNotesFirstLoad(cls);
                  return SliverToBoxAdapter(
                    child: SpinKitDualRing(color: color, lineWidth: 2.5, size: 40),
                  );
                }
                return (hasError)
                    ? SliverToBoxAdapter(child: Icon(Icons.error, color: Colors.amber, size: 45))
                    : SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 30),
                          ...cls.notes
                              .map((e) => ListTile(
                                    title: Text(e.author.displayName),
                                    subtitle: Text(e.content),
                                  ))
                              .toList(),
                          const SizedBox(height: 130),
                        ]),
                      );
              },
            ),
          ],
        ),
      ),
    );

//    if (!didFirstLoad && cls.members == null) {
//      fetchNotesFirstLoad(noteMgr, uid);
//      return FetchProgressIndicator(color: color);
//    }
//    return (hasError) ? RefreshableErrorPrompt(onRefresh: () => fetchNotes(noteMgr, uid)) : buildSliverList();
//    return buildSliverList();
  }

  Widget buildTestNote(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Themes.forClass(cls.theme).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(height: 150),
    );
  }
}
