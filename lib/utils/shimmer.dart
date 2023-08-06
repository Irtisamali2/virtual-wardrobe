import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimer() {
  return SizedBox(
    height: 200.0,
    child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, snapshot) {
          return Shimmer.fromColors(
            baseColor: Colors.white.withAlpha(150),
            highlightColor: Colors.black.withAlpha(150),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(150),
                  borderRadius: BorderRadius.circular(20)),
              height: 200,
              width: 200,
            ),
          );
        }),
  );
}
