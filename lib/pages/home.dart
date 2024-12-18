import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:san2/pages/productos.dart';
import 'package:san2/pages/sucursales.dart';
import 'package:san2/services/apiService.dart';

// import '../screens/detail_screen.dart';
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  List pages = [
    Productos(),
    Sucursales(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(Icons.home_filled,color: _currentIndex == 0 ? Colors.blue : Colors.black),
                      SizedBox(height: 3,),
                      Text('Home')
                    ],
                  ),
                ),
                // Column(
                //   children: const [
                //     Icon(Icons.add_card_rounded),
                //     SizedBox(height: 3,),
                //     Text('Voucer')
                //   ],
                // ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(Icons.wallet, color: _currentIndex == 1 ? Colors.blue : Colors.black),
                      SizedBox(height: 3,),
                      Text('Sucursales')
                    ],
                  ),
                ),
                // Column(
                //   children: const [
                //     Icon(Icons.settings),
                //     SizedBox(height: 3,),
                //     Text('Settings')
                //   ],
                // ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color(0xfFE9EBEA),
        body: pages[_currentIndex],
    );
  }
}

