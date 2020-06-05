import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/note_manager.dart';
import 'package:justclass/utils/constants.dart';
import 'package:justclass/widgets/note_tile.dart';
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
                final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
                final bottomBarHeight = isPortrait ? bottomBarPortraitHeight : bottomBarLandscapeHeight;
                final noteListHeight = MediaQuery.of(context).size.height - sliverTopBarHeight - bottomBarHeight;

                if (!didFirstLoad && noteMgr.notes == null) {
                  fetchNotesFirstLoad(cls);
                  return buildLoadingSpinner(noteListHeight, color);
                }
                return (hasError)
                    ? buildErrorPrompt(noteListHeight)
                    : (cls.notes.isEmpty)
                        ? buildNoNotePrompt(color)
                        : SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 10),
                              ...cls.notes.map((note) => NoteTile(note: note, color: color)).toList(),
                              const SizedBox(height: 140),
                            ]),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoNotePrompt(Color color) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return SliverToBoxAdapter(
      child: LayoutBuilder(builder: (context, constraint) {
        return Container(
          margin: isPortrait
              ? const EdgeInsets.all(25)
              : EdgeInsets.symmetric(horizontal: constraint.maxWidth * 0.2, vertical: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(isPortrait ? Icons.crop_portrait : Icons.crop_landscape, color: color, size: 30),
              const SizedBox(width: 10),
              const Text('Empty Board', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }),
    );
  }

  Widget buildLoadingSpinner(double noteListHeight, Color color) {
    return SliverToBoxAdapter(
      child: Container(
        height: noteListHeight,
        alignment: Alignment.center,
        child: SpinKitDualRing(color: color, lineWidth: 2.5, size: 40),
      ),
    );
  }

  Widget buildErrorPrompt(double noteListHeight) {
    return SliverToBoxAdapter(
      child: Container(
        height: noteListHeight,
        alignment: Alignment.center,
        child: const Icon(Icons.error, color: Colors.amber, size: 45),
      ),
    );
  }
}
