import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sosmap/models/state.dart';
import 'package:sosmap/ui/screens/map.dart';
import 'package:sosmap/ui/screens/profile.dart';
import 'package:sosmap/util/state_widget.dart';
import 'package:sosmap/ui/screens/sign_in.dart';
import 'package:sosmap/ui/widgets/loading.dart';
import 'package:sosmap/wemap/main.dart';
import 'package:sosmap/wemap/place_symbol.dart';
import 'package:sosmap/wemap/route.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    FullMapPage(),
    MapsDemo(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      if (index == 0 || index == 1) await location.requestPermission();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }
      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
            )),
      );

//check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final settingsId = appState?.settings?.settingsId ?? '';
      final userIdLabel = Text('App Id: ');
      final emailLabel = Text('Email: ');
      final firstNameLabel = Text('First Name: ');
      final lastNameLabel = Text('Last Name: ');
      final settingsIdLabel = Text('SetttingsId: ');

      return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingScreen(
          child: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          inAsyncCall: _loadingVisible,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'B???n ?????',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'L???ch s???',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'H??? s??',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap: _onItemTapped,
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
