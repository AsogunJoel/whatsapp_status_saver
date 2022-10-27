import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/utils/get_thumbails.dart';

class SingleVideo extends StatefulWidget {
  const SingleVideo({
    Key? key,
    this.file,
  }) : super(key: key);
  final String? file;

  @override
  State<SingleVideo> createState() => _SingleVideoState();
}

class _SingleVideoState extends State<SingleVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: getThumbnail(widget.file),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(
                        snapshot.data!,
                      ),
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text(
                          'Unavailable',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: SizedBox(
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class SingleVideo extends StatefulWidget {
//   const SingleVideo({
//     Key? key,
//     this.file,
//   }) : super(key: key);
//   final String? file;

//   @override
//   State<SingleVideo> createState() => _SingleVideoState();
// }

// class _SingleVideoState extends State<SingleVideo>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(
//       File(widget.file!),
//     )
//       ..addListener(() {
//         _changeSelect();
//       })
//       ..initialize();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }

//   void _changeSelect() {
//     if (_controller!.value.isInitialized) {
//       setState(
//         () {
//           _animatedWidget = AspectRatio(
//             aspectRatio: _controller!.value.aspectRatio,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: VideoPlayer(_controller!),
//             ),
//           );
//         },
//       );
//     } else {
//       setState(() {
//         const Padding(
//           padding: EdgeInsets.all(30.0),
//           child: SizedBox(
//             child: FittedBox(
//               child: Padding(
//                 padding: EdgeInsets.all(15.0),
//                 child: CircularProgressIndicator.adaptive(
//                   strokeWidth: 2,
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
//     }
//   }

//   Widget _animatedWidget = const Padding(
//     padding: EdgeInsets.all(30.0),
//     child: SizedBox(
//       child: Padding(
//         padding: EdgeInsets.all(15.0),
//         child: CircularProgressIndicator.adaptive(
//           strokeWidth: 2,
//         ),
//       ),
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 2000),
//       switchInCurve: Curves.easeIn,
//       switchOutCurve: Curves.easeIn,
//       transitionBuilder: (child, animation) {
//         return FadeTransition(
//           opacity: animation,
//           child: child,
//         );
//       },
//       child: _animatedWidget,
//     );
//   }
// }

// // return FutureBuilder(
//   future: getThumbnail(widget.file),
//   builder: (context, snapshot) {
//     if (snapshot.hasData &&
//         snapshot.connectionState == ConnectionState.done) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.file(
//           File(
//             snapshot.data!,
//           ),
//           errorBuilder: (context, error, stackTrace) => const Center(
//             child: Text(
//               'Unavailable',
//               textAlign: TextAlign.center,
//             ),
//           ),
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Padding(
//         padding: EdgeInsets.all(30.0),
//         child: SizedBox(
//           child: FittedBox(
//             child: Padding(
//               padding: EdgeInsets.all(15.0),
//               child: CircularProgressIndicator.adaptive(
//                 strokeWidth: 2,
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return const Text(
//         'Unavailable, please refresh',
//         textAlign: TextAlign.center,
//       );
//     }
//   },
// );
