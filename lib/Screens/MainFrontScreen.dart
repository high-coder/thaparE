import 'dart:async';

import 'package:appetizer/ProductPage/ProductScreen.dart';
import 'package:appetizer/ProductPage/models/DrawerScreenProvider.dart';
import 'package:appetizer/ProductPage/models/FeatureProvider.dart';
import 'package:appetizer/ProductPage/models/MainScreenProviders.dart';
import 'package:appetizer/ProductPage/models/SurveyProvider.dart';
import 'package:appetizer/ProductPage/models/cartProvider.dart';
import 'package:appetizer/ProductPage/models/restaurant_model.dart';
import 'package:appetizer/Screens/single_resto_screen.dart';
import 'package:appetizer/frontScreenComponents/topContainer.dart';
import 'package:appetizer/login/LoginProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'SurveyScreen.dart';
import 'components/FeaturedContainer.dart';

class MainFrontScreen extends StatefulWidget {
  @override
  _MainFrontScreenState createState() => _MainFrontScreenState();
}

class _MainFrontScreenState extends State<MainFrontScreen> {
  Future products;
  Future Featured;
  Future images;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> onLikeButtonTapped(bool isLiked, int productID) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    // print('my order is liked ${loginProvider.user.uid}');
    // _firestore
    //     .collection('user')
    //     .doc(loginProvider.user.uid.toString())
    //     .update({
    //   'currentOrder': FieldValue.arrayUnion([orderNumber.toString()])
    // });
    return !isLiked;
  }

  getFuturesFood() async {
    MainScreenProvider providerInstance =
        Provider.of<MainScreenProvider>(context, listen: false);
    FeatureProvider featureInstance =
        Provider.of<FeatureProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);
    LoginProvider loginProvider = Provider.of(context, listen: false);
    cartProvider.wishlistStartup(loginProvider.user);
    if (providerInstance.isFirstTimeInit == true) {
      providerInstance.isFirstTimeInit = false;
      await providerInstance.loadAllData();
      providerInstance.categoryData = providerInstance.abc();
      //Featured = featureInstance.getFeatureData(providerInstance.products);
      //providerInstance.GridContainer =
        //  providerInstance.convertCategory('Burger');
      cartProvider.basket = providerInstance.Basket;
      surveyProvider.tagList = providerInstance.tagList;
    }

    print('done');
  }

  callToFunc() {
    MainScreenProvider providerInstance =
    Provider.of<MainScreenProvider>(context, listen: false);
    providerInstance.tappedYes();
    CartProvider cartProvider = Provider.of(context, listen: false);

    cartProvider.cart.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> RestoScreen(indexInList: providerInstance.indexInList,)));

  }

  @override
  void initState() {
    getFuturesFood();
    super.initState();
  }

  int selectedindex = 0;

  RestaurantModel restoData = RestaurantModel(
    tags: [
      "Meal",
      "American",
      "FastFood",
    ],
    address: "Thapar E- Express",
    name: "Thapar Express",
  );



  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: false);
    CartProvider cartProvider = Provider.of(context, listen: false);
    MainScreenProvider categoryModel =
        Provider.of<MainScreenProvider>(context, listen: false);
    FeatureProvider featureInstance =
        Provider.of<FeatureProvider>(context, listen: false);
    DrawerProvider drawerProvider =
        Provider.of<DrawerProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.tag();

    final snackBar = SnackBar(
      content: const Text('You have items in your clear'),
      action: SnackBarAction(
        label: 'Proceed',
        onPressed: () {
          callToFunc();
          // Some code to undo the change.
        },
      ),
      duration: Duration(seconds: 5),


    );



    return Consumer<DrawerProvider>(
      builder: (BuildContext context, DrawerProvider value, Widget child) {
        return Stack(
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(0)),
              duration: Duration(milliseconds: 300),
              transform: Matrix4.translationValues(
                  drawerProvider.screenDistance.dx,
                  drawerProvider.screenDistance.dy,
                  0)
                ..scale(drawerProvider.scalefactor),
              child: child,
            ),

            // this is kinda like the splash screen of the application
            Consumer<MainScreenProvider>(
                builder: (BuildContext context,
                        MainScreenProvider providerValue, Widget child) =>
                    Visibility(
                        visible: providerValue.dataLoaded,
                        child: Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TasteAtlas',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.deepOrange),
                              ),
                              Lottie.asset(
                                  'assets/images/Lotties/starting.json'),
                            ],
                          ),
                        )))
          ],
        );
      },
      child: Scaffold(
        // floatingActionButton: InkWell(
        //   child: Image.asset('assets/images/confusedDog.png'),
        //   onTap: () {
        //     Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (BuildContext context) {
        //       return SurveyScreen();
        //     }));
        //   },
        // ),
        body: CustomScrollView(
          slivers: [
            // this is the top container widget of the application which will take the name and etc of the restaurant
            SliverPersistentHeader(
              pinned: false,
              floating: false,
              delegate: TopContainer(
                  maxExtent: size.height * 0.5 - 20,
                  minExtent: 300,
                  assetImage: true,
                  restoData: restoData,
                  showMenuIcon: true
              ),
            ),

            /// this is the top container in which we have the title featured writen
            // FeaturedData(),
            //
            // /// this will contain some featured restaurants with their images
            // SliverToBoxAdapter(
            //   child: Consumer<FeatureProvider>(
            //     builder: (BuildContext context, FeatureProvider value,
            //         Widget child) {
            //       return Container(
            //         height: size.height / 4 - 30,
            //         child: FutureBuilder(
            //             future: Featured,
            //             builder: (context, snapshot) {
            //               switch (snapshot.connectionState) {
            //                 case ConnectionState.none:
            //                   // TODO: Handle this case.
            //                   break;
            //                 case ConnectionState.waiting:
            //                   // TODO: Handle this case.
            //                   break;
            //                 case ConnectionState.active:
            //                   // TODO: Handle this case.
            //                   break;
            //                 case ConnectionState.done:
            //                   // TODO: Handle this case.
            //                   break;
            //               }
            //               if (featureInstance.feature.isEmpty) {
            //                 return ListView.builder(
            //                   itemCount: 4,
            //                   scrollDirection: Axis.horizontal,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return Shimmer.fromColors(
            //                         child: Container(
            //                             height: size.height / 4,
            //                             margin: EdgeInsets.only(
            //                                 left: 10, right: 10),
            //                             width: size.width - 120,
            //                             decoration: BoxDecoration(
            //                               color: Colors.blueGrey.shade200,
            //                               borderRadius:
            //                                   BorderRadius.circular(20),
            //                             )),
            //                         baseColor: Colors.grey.shade300,
            //                         highlightColor:
            //                             Colors.white.withOpacity(0.5));
            //                   },
            //                 );
            //               }
            //               return ListView.builder(
            //                 addAutomaticKeepAlives: true,
            //                 scrollDirection: Axis.horizontal,
            //                 itemCount: featureInstance.feature.length == null
            //                     ? 0
            //                     : featureInstance.feature.length,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   bool Liked = false;
            //                   if (cartProvider.wishlist.contains(
            //                       featureInstance.feature[index].id)) {
            //                     Liked = true;
            //                   }
            //                   return GestureDetector(
            //                       onTap: () {
            //                         // this will redirect them to the restaurant page
            //
            //                         Navigator.of(context)
            //                             .push(MaterialPageRoute(
            //                                 builder: (context) => ProductPage(
            //                                       data: featureInstance
            //                                           .feature[index],
            //                                       index: index,
            //                                     )));
            //                       },
            //                       child: Hero(
            //                         tag: featureInstance.feature[index].id,
            //                         child: FeatureContainer(
            //                           index: index,
            //                           liked: Liked,
            //                         ),
            //                       ));
            //                 },
            //               );
            //             }),
            //       );
            //     },
            //   ),
            // ),

            SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),

            SliverToBoxAdapter(
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Text("Top Rated Restos!!!", style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )
                )),
              )
            ),
            /// These are the list tiles of the single single restaurants
            SliverToBoxAdapter(
              child: Consumer<MainScreenProvider>(
                builder: (context, _, __) {
                  if (categoryModel.restaurantsAll.isEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      //scrollDirection: Axis.horiz,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                            child: Container(
                                height: size.height / 10,
                                margin: EdgeInsets.only(left: 10, right: 10,top: 20),
                                width: size.width - 120,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white.withOpacity(0.5)
                        );
                      },
                    );
                  } else {

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap:() {

                                // changing the global uid of the restaurant model
                                categoryModel.globalRestoUidOld = categoryModel.globalRestoUid;
                                 String tempUid= categoryModel.restaurantsAll[index].uid;
                                if(tempUid == categoryModel.globalRestoUidOld) {
                                  // do nothing
                                  categoryModel.dataLoadedResto = false;
                                  categoryModel.globalRestoUid = categoryModel.restaurantsAll[index].uid;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RestoScreen(indexInList: index,)));
                                } else {

                                  if(cartProvider.cart.isNotEmpty){
                                    // show the confirmation message to the user
                                    categoryModel.indexInList = index;
                                    //print(categoryModel.restaurantsAll[index].productsIds);

                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {

                                    print(categoryModel.restaurantsAll[index].productsIds);

                                    categoryModel.globalRestoUid = categoryModel.restaurantsAll[index].uid;
                                    categoryModel.getProductsRestaurants(categoryModel.restaurantsAll[index].productsIds,categoryModel.restaurantsAll[index].featuredItems);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RestoScreen(indexInList: index,)));

                                  }
                                }
                                //categoryModel.getProductsRestaurants(categoryModel.restaurantsAll[index].productsIds,categoryModel.restaurantsAll[index].featuredItems);


                                print("----------------------------------");
                                print(categoryModel.restaurantsAll[0].tags);
                                print("----------------------------------");
                              },
                              child: Container(
                                //height:60,
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 7,
                                        offset: Offset(0,
                                            1), //// c// hanges position of shadow
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff476BB5),
                                        Color(0xff73BCF8),
                                        Color(0xff476BB5),
                                        Color(0xffF86B6C),

                                        // ThemeProvider.themeOf(context).data.primaryColorDark,
                                        // ThemeProvider.themeOf(context).data.primaryColorLight,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CachedNetworkImage(
                                        imageUrl: categoryModel
                                            .restaurantsAll[index].images[0],
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                            categoryModel
                                                .restaurantsAll[index].name,
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            )))),
                                    Spacer(flex: 1),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        //width:50,
                                        //height: 50,
                                        child: RatingBar.builder(
                                          itemSize: 8,
                                          glow: true,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          //allowHalfRating: true,
                                          itemCount: 5,
                                          //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ),
                                    )
                                    //Text("4 star")
                                  ],
                                ),
                              ),
                            ),
                            //SizedBox(height: 10),
                          ],
                        );
                      },
                      itemCount: categoryModel.restaurantsAll.length,
                    );
                  }
                },
              ),
            ),
            //
            // SliverToBoxAdapter(
            //   child: Container(
            //     margin: EdgeInsets.only(top: 20),
            //     height: 50,
            //     child: Consumer<MainScreenProvider>(builder:
            //         (BuildContext context, MainScreenProvider value,
            //             Widget child) {
            //       return FutureBuilder(
            //         future: value.categoryData,
            //         builder: (BuildContext context,
            //                 AsyncSnapshot<dynamic> snapshot) =>
            //             ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: value.category.length == null
            //               ? 0
            //               : value.category.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 selectedindex = categoryModel.selectedCategory(
            //                     index, selectedindex);
            //                 print(selectedindex);
            //                 value.GridContainer = categoryModel
            //                     .convertCategory(snapshot.data[index].name);
            //               },
            //               child: Container(
            //                   margin:
            //                       EdgeInsets.only(left: 10, right: 10, top: 10),
            //                   child: Text(
            //                     categoryModel.category[index].name,
            //                     style: TextStyle(
            //                         color: selectedindex != null &&
            //                                 selectedindex == index
            //                             ? Colors.black
            //                             : Colors.grey,
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18),
            //                   )),
            //             );
            //           },
            //         ),
            //       );
            //     }),
            //   ),
            // ),
            // Consumer<MainScreenProvider>(
            //   builder: (context, value, child) {
            //     return FutureBuilder(
            //       builder:
            //           (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //         return SliverGrid(
            //           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //             maxCrossAxisExtent: 300,
            //             mainAxisSpacing: 20,
            //             crossAxisSpacing: 14,
            //             childAspectRatio: size.width / (size.height * 0.6), //
            //           ),
            //           delegate: SliverChildBuilderDelegate(
            //             (BuildContext context, int index) {
            //               bool wishlistLiked = false;
            //               if (cartProvider.wishlist
            //                   .contains(categoryModel.GridFood[index].id)) {
            //                 wishlistLiked = true;
            //               }
            //               return GestureDetector(
            //                 onTap: () {
            //                   print(categoryModel.GridFood[index].id);
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (_) => ProductPage(
            //                               data: categoryModel.GridFood[index],
            //                               index: index,
            //                             )),
            //                   );
            //                 },
            //                 child: Container(
            //                   height: size.height * 0.25,
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(20),
            //                       boxShadow: [
            //                         BoxShadow(
            //                             color: Colors.grey.shade200,
            //                             spreadRadius: 4,
            //                             offset: Offset(0, 0),
            //                             blurRadius: 2)
            //                       ]),
            //                   child: Column(
            //                     children: [
            //                       Container(
            //                         height: size.height * 0.25,
            //                         child: Stack(
            //                           children: [
            //                             Container(
            //                               height: size.height * 0.23,
            //                               child: ClipRRect(
            //                                   borderRadius: BorderRadius.only(
            //                                       topLeft: Radius.circular(20),
            //                                       topRight:
            //                                           Radius.circular(20)),
            //                                   child: CachedNetworkImage(
            //                                     fit: BoxFit.fitHeight,
            //                                     imageUrl: categoryModel
            //                                         .GridFood[index].url,
            //                                     progressIndicatorBuilder: (context,
            //                                             url,
            //                                             downloadProgress) =>
            //                                         Lottie.asset(
            //                                             'assets/images/Lotties/loading.json'),
            //                                     errorWidget:
            //                                         (context, url, error) =>
            //                                             Icon(Icons.error),
            //                                   )),
            //                             ),
            //                             Positioned(
            //                               top: 10,
            //                               left: 10,
            //                               child: Container(
            //                                 width: size.width / 2 - 30,
            //                                 child: Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .spaceBetween,
            //                                   children: [
            //                                     LikeButton(
            //                                       isLiked: wishlistLiked,
            //                                       size: 23,
            //                                       likeBuilder: (bool isLiked) {
            //                                         return Image.asset(
            //                                           'assets/images/ingredients/heart_like_love_twitter_icon_127132.png',
            //                                           color: isLiked
            //                                               ? Colors.pink
            //                                               : Colors.white,
            //                                         );
            //                                       },
            //                                       onTap: (isLiked) async {
            //                                         cartProvider.wishlistLiked(
            //                                             isLiked,
            //                                             loginProvider.user,
            //                                             categoryModel
            //                                                 .GridFood[index]
            //                                                 .id);
            //                                         print('i was liked ');
            //
            //                                         return !isLiked;
            //                                       },
            //                                     ),
            //                                     Container(
            //                                       width: 60,
            //                                       height: 25,
            //                                       decoration: BoxDecoration(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   20),
            //                                           color: Colors.white),
            //                                       child: Center(
            //                                           child: RichText(
            //                                         text: TextSpan(children: [
            //                                           TextSpan(
            //                                               text: 'Rs',
            //                                               style: TextStyle(
            //                                                   fontSize: 10,
            //                                                   color: Colors
            //                                                       .deepOrangeAccent,
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .bold)),
            //                                           TextSpan(
            //                                               text: categoryModel
            //                                                   .GridFood[index]
            //                                                   .price
            //                                                   .toString(),
            //                                               style: TextStyle(
            //                                                   fontSize: 13,
            //                                                   color:
            //                                                       Colors.black,
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .bold))
            //                                         ]),
            //                                       )),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                             Positioned(
            //                               bottom: 0,
            //                               right: 10,
            //                               child: CartItem(
            //                                 index: index,
            //                               ),
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                       Container(
            //                           alignment: Alignment.center,
            //                           child: Text(
            //                             categoryModel.GridFood[index].name,
            //                             overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.center,
            //                             style: TextStyle(
            //                               fontSize: 13,
            //                               textBaseline: TextBaseline.alphabetic,
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                           )),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //             childCount: categoryModel.GridFood.length,
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class FeaturedData extends StatefulWidget {
  @override
  _FeaturedDataState createState() => _FeaturedDataState();
}

class _FeaturedDataState extends State<FeaturedData> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeatureProvider>(
        builder: (BuildContext context, FeatureProvider value, Widget child) =>
            Container(
          margin: EdgeInsets.only(bottom: 20, top: 12),
          padding: EdgeInsets.only(left: 20, right: 20),
          //height: 100,
          //child: Image(image: AssetImage("assets/images/new/bgmain.jpg"),height: 200,width: 200, fit: BoxFit.fitWidth,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Featured Items",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        child: Center(
                            child: Text(
                          value.feature.length == null
                              ? 0
                              : value.feature.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        )),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final int index;

  const CartItem({Key key, this.index}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    int localIndex = widget.index;

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);
    MainScreenProvider gridProvider =
        Provider.of<MainScreenProvider>(context, listen: false);

    String id = gridProvider.GridFood[widget.index].id;
    cartProvider.basket.forEach((element) {
      if (element.id == id) {
        localIndex = cartProvider.basket.indexOf(element);
      }
    });

    bool isFirstTime = cartProvider.basket[localIndex].isFirstTime;
    int quantity = cartProvider.basket[localIndex].quantity;
    return Consumer<CartProvider>(
      builder: (context, CartProvider instanceV, Widget child) {
        return child;
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 1,
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                  color: Colors.grey.shade200)
            ],
            // border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: isFirstTime
            ? InkWell(
                onTap: () {
                  cartProvider.firstTime(
                      widget.index, gridProvider.GridFood[widget.index]);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.deepOrange,
                    size: 25,
                  ),
                ),
              )
            : Container(
                height: 30,
                width: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        cartProvider.decrement(widget.index,
                            gridProvider.GridFood[widget.index].id);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        child: Center(
                            child: Text(
                          '-',
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                    ),
                    Text(
                      quantity.toString(),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        cartProvider.increment(widget.index,
                            gridProvider.GridFood[widget.index].id);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        child: Center(child: Text('+')),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
