import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// import '../screens/detail_screen.dart';
class MainHomePage extends StatelessWidget {
  const  MainHomePage({Key? key}) : super(key: key);
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
                Column(
                  children: const [
                    Icon(Icons.home_filled,color: Color(0xff2A977D),),
                    SizedBox(height: 3,),
                    Text('Home')
                  ],
                ),
                // Column(
                //   children: const [
                //     Icon(Icons.add_card_rounded),
                //     SizedBox(height: 3,),
                //     Text('Voucer')
                //   ],
                // ),
                Column(
                  children: const [
                    Icon(Icons.wallet),
                    SizedBox(height: 3,),
                    Text('Sucursales')
                  ],
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
        body:ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,left: 18,right: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 280,
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search,size: 40,color: Colors.grey,),
                              hintText: 'Buscar..',
                              hintStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      const Badge(
                        label: Text('1'),
                        child:  Image(
                            height: 30,
                            width: 30,
                            image: AssetImage('assets/icons/img.png',)),
                      ),

                      // const SizedBox(width: 10,),
                      // const Badge(
                      //   label: Text('9+'),
                      //   child:  Image(
                      //       height: 30,
                      //       width: 30,
                      //       image: AssetImage('assets/icons/chat.png',)),
                      // ),
                    ],
                  ),
                ),
                // Container(
                //     height: 180,
                //     width: 400,
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(
                //           image: AssetImage(
                //             'assets/images/main.png',
                //           )),
                //     )
                // ),
                CarouselSlider(
                  options: CarouselOptions(height: 180.0),
                  items: [1,2,3,4,5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.amber
                            ),
                            // child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Productos',style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                      Text('Ver mas',style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2A977D),
                      ),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,
                      left: 12,right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 250,
                        width: 170,
                        color:Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Image(
                              height: 118,
                              image: AssetImage(
                                  'assets/images/shirt1.png'
                              ),),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Shirt',style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text("Essential Men's Short-\nSleeve Crewneck",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.star,color: Colors.orange,),
                                      Text('4.9 | 2336',style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text('\$12.00',style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xff2A977D)
                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage()));
                        },
                        child: Container(
                          height: 257,
                          width: 170,
                          color:Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Image(
                                height: 124,
                                image: AssetImage(
                                    'assets/images/shirt4.png'
                                ),),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Shirt',style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text("Essential Men's Short-\nSleeve Crewneck T-Shirt",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.star,color: Colors.orange,),
                                        Text('4.9 | 2336',style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('\$12.00',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xff2A977D)
                                        ),)
                                      ],
                                    )
                                  ],
                                ),
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
          ],
        )
    );
  }
}
