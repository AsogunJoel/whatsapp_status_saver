import 'dart:io';

import 'package:flutter/material.dart';

class SingleGridImage extends StatefulWidget {
  const SingleGridImage({
    Key? key,
    this.filePath,
  }) : super(key: key);
  final String? filePath;
  @override
  State<SingleGridImage> createState() => _SingleGridImageState();
}

class _SingleGridImageState extends State<SingleGridImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(
            widget.filePath.toString(),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
