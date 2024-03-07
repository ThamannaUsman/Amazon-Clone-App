import 'package:amazon_app/utils/color_theme.dart';
import 'package:amazon_app/utils/constants.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  int currentAd = 0;
  double smallAdWidget=120;



  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);

    return GestureDetector(
      onHorizontalDragEnd: (_)
    {
      if(currentAd == (largeAds.length - 1)){
        currentAd = -1;
      }
      setState(() {
        currentAd++;
      });
    },

      child: Column(
        children: [
          Stack(children: [
            Image.network(
              largeAds[currentAd],
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenSize.width,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withOpacity(0)
                    ]
                  )
                ),
              ),
            )
          ]),
          Container(
            color: backgroundColor,
            width: screenSize.width,
            height: smallAdWidget,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getSmallAdsFromIndex(0, smallAdWidget),
                getSmallAdsFromIndex(1, smallAdWidget),
                getSmallAdsFromIndex(2, smallAdWidget),
                getSmallAdsFromIndex(3, smallAdWidget),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget getSmallAdsFromIndex(int index,double height){
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          height: height,
          width: height,
          decoration: ShapeDecoration(
            color: Colors.white,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(smallAds[index]),
                const SizedBox(height: 5,),
                Text(adItemNames[index])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
