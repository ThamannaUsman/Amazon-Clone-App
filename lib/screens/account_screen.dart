import 'package:amazon_app/models/product_model.dart';
import 'package:amazon_app/models/request_order_model.dart';
import 'package:amazon_app/models/user_details_model.dart';
import 'package:amazon_app/providers/user_details_provider.dart';
import 'package:amazon_app/screens/sell_screen.dart';
import 'package:amazon_app/utils/color_theme.dart';
import 'package:amazon_app/utils/constants.dart';
import 'package:amazon_app/utils/utils.dart';
import 'package:amazon_app/widgets/account_screen_app_bar.dart';
import 'package:amazon_app/widgets/button_widget.dart';
import 'package:amazon_app/widgets/products_showcase.dart';
import 'package:amazon_app/widgets/simple_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const AccountScreenAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              children: [
                const IntroductionWidgetAccountScreen(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomMainButton(
                    color: Colors.orange,
                    isLoading: false,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomMainButton(
                    color: yellowColor,
                    isLoading: false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SellScreen()));
                    },
                    child: const Text(
                      "Sell",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("orders")
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          List<Widget> children = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            ProductModel model = ProductModel.getModelFromJson(
                                json: snapshot.data!.docs[i].data());
                            children
                                .add(SimpleProductWidget(productModel: model));
                          }
                          return ProductShowCase(
                              title: "Your Orders", children: children);
                        }
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Order Requests",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("orderRequests")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                OrderRequestModel model =
                                    OrderRequestModel.getModelFromJson(
                                        json:
                                            snapshot.data!.docs[index].data());
                                return ListTile(
                                  title: Text(
                                    "Order:${model.orderName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Address:${model.buyersAddress}",
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("orderRequests")
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                      },
                                      icon: const Icon(Icons.check)),
                                );
                              });
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }
}

class IntroductionWidgetAccountScreen extends StatelessWidget {
  const IntroductionWidgetAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserDetailsModel userDetailsModel =
        Provider.of<UserDetailsProvider>(context).userDetails;
    return Container(
      height: kAppBarHeight / 2,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: backgroundGradient,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
      )),
      child: Container(
        height: kAppBarHeight / 2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.000000000001)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Hello,",
                  style: TextStyle(color: Colors.grey[800], fontSize: 26),
                ),
                TextSpan(
                  text: "${userDetailsModel.name}",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                )
              ])),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://imgs.search.brave.com/KIfRCiUno_SICLxzD4b09G410bVWB8YbB8rCiqeCk_8/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE1/MDA0NDk5MS9waG90/by93YXRlci1sZXR0/ZXItdC5qcGc_cz02/MTJ4NjEyJnc9MCZr/PTIwJmM9aVlIZUVk/blFaX2Fyb1NLYW1E/ZngtRC15V0trckJl/R0ZMT0tUU3ZWZGFY/MD0"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
