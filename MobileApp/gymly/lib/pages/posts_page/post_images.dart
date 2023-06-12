import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gymly/models/post.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostImages extends StatefulWidget {
  final Post post;
  const PostImages({required this.post, super.key});

  @override
  State<PostImages> createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  int activeIndex = 0;
  final resourceUrl = dotenv.env["RESOURCE_URL"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
            options: CarouselOptions(
              clipBehavior: Clip.hardEdge,
              enableInfiniteScroll: false,
              height: 450,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
            itemCount: widget.post.imageUrls.length,
            itemBuilder: (context, index, realIndex) =>
                buildImage(widget.post.imageUrls[index], index)),
        Positioned(
          bottom: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: widget.post.imageUrls.length,
            effect: WormEffect(
                activeDotColor: Colors.black,
                dotColor: Colors.black.withOpacity(0.3),
                dotHeight: 9,
                dotWidth: 9),
          ),
        )
      ],
    );
  }

  Widget buildImage(String imageUrl, int index) {
    return Container(
      width: double.infinity,
      child: Image.network(
        "$resourceUrl/$imageUrl",
        fit: BoxFit.cover,
      ),
    );
  }
}
