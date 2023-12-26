import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:iconsax/iconsax.dart';

class UserControls extends StatelessWidget {
  final bool isLiked;
  final Function onTapLike;
  final Function onRefresh;
  final Function onShare;

  const UserControls({
    super.key,
    required this.isLiked,
    required this.onTapLike,
    required this.onRefresh,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          //************************Custom Like Button***************************
          child: LikeButton(
            isLiked: isLiked,
            onTap: (bool isCurrentlyLiked) {
              onTapLike(isCurrentlyLiked);
              return Future.value(!isCurrentlyLiked);
            },
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.white,
                size: 30,
              );
            },
          ),
        ),

        //************************Refresh Button***************************
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: IconButton(
            icon: const Icon(
              Iconsax.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              onRefresh();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              elevation: MaterialStateProperty.all<double>(0),
            ),
          ),
        ),

        //************************share Button***************************
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              onShare();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              elevation: MaterialStateProperty.all<double>(0),
            ),
          ),
        ),
      ],
    );
  }
}
