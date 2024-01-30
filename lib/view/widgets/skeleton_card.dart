import 'package:flutter/material.dart';
import 'package:peanut/view/widgets/skeleton.dart';

import '../../network/url.dart';


class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Skeleton(
                  height: Utils.responsiveWidth(context,170.0),
                  width: Utils.responsiveWidth(context,120.0),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(width: 300,),
                      SizedBox(height: 10),
                      Skeleton(width: 150,),
                      SizedBox(height: 10),
                      Skeleton(width: 150,),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Skeleton(height: 40,)),
                          SizedBox(width: 16),
                          Expanded(child: Skeleton(height: 40,)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Skeleton(height: 40,)),
                          SizedBox(width: 16),
                          Expanded(child: Skeleton(height: 40,)),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Skeleton(width:double.infinity,height: 55,),
          ],
        ),
      ),
    );
  }
}
