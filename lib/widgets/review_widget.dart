import 'package:amazon_app/models/review_model.dart';
import 'package:amazon_app/utils/constants.dart';
import 'package:amazon_app/utils/utils.dart';
import 'package:amazon_app/widgets/rating_star_widget.dart';
import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    Size screenSize=Utils().getScreenSize(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.senderName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: screenSize.width/4,
                    child: FittedBox(child: RatingStarWidget(rating: review.rating),),
                  ),
                ),
                Text(keyOfRating[review.rating - 1],style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          Text(review.description,maxLines: 3,overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}
