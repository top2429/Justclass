import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/all_themes.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/fetch_error_icon.dart';
import 'package:justclass/widgets/fetch_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'once_future_builder.dart';

enum ViewType { ALL, TEACHING, JOINED, ASSISTING }

class ClassListView extends StatelessWidget {
  final ViewType viewType;

  const ClassListView({this.viewType});

  @override
  Widget build(BuildContext context) {
    return OnceFutureBuilder(
      future: Provider.of<ClassManager>(context, listen: false).fetchData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return FetchProgressIndicator();
        if (snapshot.error != null) return FetchErrorPrompt();
        return RefreshIndicator(
          color: AllThemes.primaryColor,
          onRefresh: () async {
            try {
              await Provider.of<ClassManager>(context, listen: false).fetchData();
            } catch (error) {
              AppSnackBar.show(context, message: error.toString());
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: double.infinity,
                        child: Hero(
                          tag: 'theme',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(AllThemes.classTheme(0).imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black26,
                          child: InkWell(
                            splashColor: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {},
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              DefaultTextStyle.merge(
                                style: TextStyle(color: Colors.white, fontSize: 17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                    Text('Section'),
                                    Spacer(),
                                    Text('Number of student'),
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: PopupMenuButton(
                                      child: Icon(Icons.more_vert),
                                      onSelected: (val) {},
                                      itemBuilder: (_) => [
                                        PopupMenuItem(
                                          child: Text('Leave'),
                                        ),
                                      ],
                                      offset: Offset(0, 50),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClassListViewTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[],
    );
  }
}
