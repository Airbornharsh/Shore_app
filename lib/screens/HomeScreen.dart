import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Components/HomeScreen/Home.dart';
import 'package:shore_app/Components/HomeScreen/Profile.dart';
import 'package:shore_app/Components/HomeScreen/Requests.dart';
import 'package:shore_app/Components/HomeScreen/Upload.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    void onLoad() async {
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("hopl_backend_uri", "http://localhost:3000");
      prefs.setString("shore_backend_uri", "http://10.0.2.2:3000");
      // prefs.setString("hopl_backend_uri", "https://hopl.vercel.app");
    }

    onLoad();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedWidget = [
      const Home(),
      const Requests(),
      const Profile()
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              actions: [
                if (!Provider.of<User>(context).getIsAuth)
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AuthScreen.routeName);
                      },
                      icon: const Icon(Icons.login)),
                const SizedBox(
                  width: 10,
                )
              ],
              toolbarHeight: 130,
              title: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 80 / 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 1, 214, 207),
                        borderRadius: BorderRadius.circular(60)),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          icon: Icon(Icons.search, color: Colors.white),
                          iconColor: Colors.white,
                          suffixIconColor: Colors.white),
                    )),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: 0,
        iconSize: 30,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: selectedWidget[_selectedIndex],
    );
  }
}
