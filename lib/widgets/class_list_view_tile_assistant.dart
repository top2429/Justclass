import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class ClassListViewTileAssistant extends StatelessWidget {
  final _radius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 130,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: _radius,
              child: Consumer<Class>(
                builder: (_, data, __) => Hero(
                  tag: data.cid,
                  child: Image.asset(Themes.classTheme(data.theme).imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              borderRadius: _radius,
              color: Colors.black12,
              child: InkWell(
                splashColor: Colors.black12,
                borderRadius: _radius,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: DefaultTextStyle.merge(
                            style: const TextStyle(color: Colors.white),
                            child: Consumer<Class>(builder: (_, data, __) {
                              final studentCount = data.studentCount;
                              final countStr = studentCount == 1 ? '$studentCount student' : '$studentCount students';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    data.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(data.section,
                                      style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                                  Spacer(),
                                  Text(countStr, style: const TextStyle(fontSize: 14)),
                                ],
                              );
                            })),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          offset: const Offset(0, 40),
                          itemBuilder: (_) => [
                            const PopupMenuItem(child: Text('Edit'), value: 'edit', height: 40),
                          ],
                          onSelected: (val) {},
                        ),
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
