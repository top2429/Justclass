import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:provider/provider.dart';

import '../all_themes.dart';

class ClassListViewTileStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            child: Hero(
              tag: 'theme',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Consumer<Class>(
                  builder: (_, data, __) => Image.asset(AllThemes.classTheme(data.theme).imageUrl, fit: BoxFit.cover),
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: DefaultTextStyle.merge(
                          style: const TextStyle(color: Colors.white),
                          child: Consumer<Class>(
                            builder: (_, data, __) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(data.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                Text(data.section, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Spacer(),
                                Text(data.studentCount.toString(), style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          offset: Offset(0, 40),
                          onSelected: (val) {},
                          itemBuilder: (_) => [
                            PopupMenuItem(child: Text('Leave')),
                            PopupMenuItem(child: Text('Report')),
                          ],
                        ),
//                                Container(
//                                  width: 10,
//                                  height: 10,
//                                  margin: const EdgeInsets.all(10),
//                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//                                ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
