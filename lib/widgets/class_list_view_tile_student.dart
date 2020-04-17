import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:provider/provider.dart';

import '../all_themes.dart';

class ClassListViewTileStudent extends StatelessWidget {
  final _radius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: _radius,
              child: Consumer<Class>(
                builder: (_, data, __) => Hero(
                  tag: data.cid,
                  child: Image.asset(AllThemes.classTheme(data.theme).imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              borderRadius: _radius,
              color: Colors.black38,
              child: InkWell(
                splashColor: Colors.black12,
                borderRadius: _radius,
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
                                Text(data.ownerName, style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          offset: const Offset(0, 40),
                          itemBuilder: (_) => [
                            const PopupMenuItem(child: Text('Leave'), value: 'leave'),
                            const PopupMenuItem(child: Text('Report'), value: 'report'),
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
