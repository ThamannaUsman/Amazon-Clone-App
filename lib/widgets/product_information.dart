import 'package:amazon_app/utils/color_theme.dart';
import 'package:amazon_app/utils/utils.dart';
import 'package:amazon_app/widgets/cost_widget.dart';
import 'package:flutter/material.dart';

class ProductInformationWidget extends StatelessWidget {
  final String productName;
  final double cost;
  final String sellerName;

 const  ProductInformationWidget(
      {super.key,
      required this.productName,
      required this.cost,
      required this.sellerName});



  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    SizedBox spaceThingy=const SizedBox(height: 7,);
    return SizedBox(
      width: screenSize.width / 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            productName,
            maxLines: 2,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.7,
                overflow: TextOverflow.ellipsis),
          ),
          spaceThingy,
          Align(
              alignment: Alignment.center,
              child: CostWidget(color: Colors.black, cost: cost)),
          spaceThingy,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Sold by ",
                style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            TextSpan(
                text: sellerName,
                style: const TextStyle(color: activeCyanColor, fontSize: 14))
          ]))
        ],
      ),
    );
  }
}
