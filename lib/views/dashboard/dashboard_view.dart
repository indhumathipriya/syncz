import 'package:flutter/material.dart';
import 'package:syncz/views/home_view.dart';
import 'package:syncz/views/post_view.dart';
import 'package:syncz/views/profile_view.dart';

import '../../confiqs/shared.dart/constant.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const PostView(),
    ProfileView(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Constant.appPrimary,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home_rounded,
                  size: 32,
                ),
                icon: Icon(
                  Icons.home,
                  size: 32,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.add_circle_outline_outlined,
                  size: 32,
                ),
                icon: Icon(
                  Icons.add,
                  size: 32,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.person_rounded,
                  size: 32,
                ),
                icon: Icon(
                  Icons.person,
                  size: 32,
                ),
                label: 'Profile',
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: selectedIndex,
            selectedItemColor: Constant.appSecondary,
            onTap: _onItemTapped,
            elevation: 0),
      ),
    );
  }
}
