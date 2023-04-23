import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;

  late StreamSink<bool> isSidebarOpenedSink;
  final bool isSidebarOpened = true;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close(); // перекласти
    isSidebarOpenedSink.close();
    super.dispose();
  }

  @override
  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationComoleted = animationStatus == AnimationStatus.completed;

    if (isAnimationComoleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
        initialData: false,
        stream: isSidebarOpenedStream,
        builder: (context, snapshot) {
          final isSideBarOpenedAsync = snapshot.data;
          if (isSideBarOpenedAsync == null) {
            return Container();
          }
          return AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: isSideBarOpenedAsync ? 0 : -screenWidth,
            right: isSideBarOpenedAsync ? 0 : screenWidth - 45,
            duration: _animationDuration,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.blueAccent,
                    child: Column(children: const <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      ListTile(
                        title: Text(
                          "Rauph",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 30,
                              fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          "rauph@gnail.com",
                          style: TextStyle(
                              color: Color.fromARGB(255, 131, 124, 231),
                              fontSize: 20),
                        ),
                        leading: CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.perm_identity, color: Colors.white),
                        ),
                      )
                    ]),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.9), //саме вікно бокове
                  child: GestureDetector(
                    onTap: () {
                      onIconPressed();
                    },
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.blueAccent,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        //icon menu
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.blueGrey,
                        size: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
