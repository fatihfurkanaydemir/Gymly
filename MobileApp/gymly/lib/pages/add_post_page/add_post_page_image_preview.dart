import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddPostPageImagePreview extends StatefulWidget {
  final List<XFile> imageFileList;
  const AddPostPageImagePreview({required this.imageFileList, super.key});

  @override
  State<AddPostPageImagePreview> createState() =>
      _AddPostPageImagePreviewState();
}

class _AddPostPageImagePreviewState extends State<AddPostPageImagePreview> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
            options: CarouselOptions(
              clipBehavior: Clip.hardEdge,
              enableInfiniteScroll: false,
              height: double.infinity,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
            itemCount: widget.imageFileList.length,
            itemBuilder: (context, index, realIndex) =>
                buildImage(widget.imageFileList[index], index)),
        Positioned(
          bottom: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: widget.imageFileList.length,
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

  Widget buildImage(XFile file, int index) {
    return Container(
      width: double.infinity,
      child: Image.file(
        File(file.path),
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                const Center(child: Text('This image type is not supported')),
      ),
    );
  }
}
