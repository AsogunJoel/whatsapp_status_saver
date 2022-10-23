import 'dart:io';

import 'package:flutter/material.dart';

class SinglePageImage extends StatefulWidget {
  const SinglePageImage({
    Key? key,
    this.filePath,
  }) : super(key: key);
  final String? filePath;
  @override
  State<SinglePageImage> createState() => _SinglePageImageState();
}

class _SinglePageImageState extends State<SinglePageImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(
            widget.filePath.toString(),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Text(
              'Unavailable, please refresh',
              textAlign: TextAlign.center,
            ),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
