
import 'package:amazon_app/models/product_model.dart';
import 'package:amazon_app/models/review_model.dart';
import 'package:amazon_app/providers/user_details_provider.dart';
import 'package:amazon_app/resources/cloudfirestore_method.dart';
import 'package:amazon_app/utils/color_theme.dart';
import 'package:amazon_app/utils/constants.dart';
import 'package:amazon_app/utils/utils.dart';
import 'package:amazon_app/widgets/button_widget.dart';
import 'package:amazon_app/widgets/cost_widget.dart';
import 'package:amazon_app/widgets/custom_simple_rounded_button.dart';
import 'package:amazon_app/widgets/rating_star_widget.dart';
import 'package:amazon_app/widgets/review_dialog.dart';
import 'package:amazon_app/widgets/review_widget.dart';
import 'package:amazon_app/widgets/search_bar_widget.dart';
import 'package:amazon_app/widgets/user_detail_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel productModel;

  const ProductScreen({super.key, required this.productModel});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Expanded spaceThingy = Expanded(child: Container());

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    return SafeArea(
        child: Scaffold(
      appBar: SearchBarWidget(isReadOnly: true, hasBackButton: true),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height:
                      screenSize.height - (kAppBarHeight + (kAppBarHeight / 2)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kAppBarHeight / 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    widget.productModel.sellerName,
                                    style: const TextStyle(
                                        color: activeCyanColor, fontSize: 16),
                                  ),
                                ),
                                Text(widget.productModel.productName)
                              ],
                            ),
                            RatingStarWidget(
                              rating: widget.productModel.rating,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: screenSize.height / 3,
                          constraints:
                              BoxConstraints(maxHeight: screenSize.height / 3),
                          child: Image.network(widget.productModel.url),
                        ),
                      ),
                      spaceThingy,
                      CostWidget(
                          color: Colors.black, cost: widget.productModel.cost),
                      spaceThingy,
                      CustomMainButton(
                          child: const Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.orange,
                          isLoading: false,
                          onPressed: () async {
                            await CloudFireStoreClass().addProductToOrders(
                                model: widget.productModel,
                                userDetails: Provider.of<UserDetailsProvider>(
                                        context,
                                        listen: false)
                                    .userDetails);
                            Utils().showSnackBar(
                                context: context, content: "Done");
                          }),
                      spaceThingy,
                      CustomMainButton(
                          child: const Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: yellowColor,
                          isLoading: false,
                          onPressed: () async {
                            await CloudFireStoreClass().addProductToCart(
                                productModel: widget.productModel);
                          }),
                      spaceThingy,
                      CustomSimpleRoundedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => ReviewDialog(
                                    productUid: widget.productModel.uid));
                            Utils().showSnackBar(
                                context: context, content: "Added to cart");
                          },
                          text: "Add a review for this product")
                    ],
                  ),
                ),
                SizedBox(
                    height: screenSize.height,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .doc(widget.productModel.uid)
                          .collection("reviews")
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
                                ReviewModel model =
                                    ReviewModel.getModelFromJson(
                                        json:
                                            snapshot.data!.docs[index].data());
                                return ReviewWidget(review: model);
                              });
                        }
                      },
                    ))
              ],
            ),
          )),
          const UserDetailBar(
            offset: 0,
          )
        ],
      ),
    ));
  }
}
