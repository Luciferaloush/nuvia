import 'package:flutter/material.dart';

class TabBarScreen extends StatelessWidget {
  final Size size;

  const TabBarScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: new PreferredSize(
              preferredSize: size * 0.95,
              child: new Container(
                child: new SafeArea(
                    child: new Column(
                  children: <Widget>[
                    new TabBar(
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      isScrollable: true,
                      tabs: [
                        new Text('Tweets'),
                        new Text('replies'),
                        new Text('Media'),
                        new Text('Likes'),
                      ],
                    )
                  ],
                )),
              )),
          body: new TabBarView(children: [
            new Text("one"),
            new Text("Two"),
            new Text("Three"),
            new Text("Four")
          ]),
        ),
      ),
    );
  }
}
