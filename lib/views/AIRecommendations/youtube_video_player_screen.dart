import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../utils/app_colors.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final dynamic data;
  final dynamic title;
  final dynamic desc;

  const YoutubeVideoPlayerScreen({
    super.key,
    this.data,
    this.title,
    this.desc,
  });

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  YoutubePlayerController? youtubePlayerController;
  late VideoPlayerController videoPlayer;
  @override
  void initState() {
    // TODO: implement initState
    // var id = YoutubePlayer.convertUrlToId(widget.data);
    var id = convertUrlToId(widget.data);
    // widget.data
    // var id = widget.data.toString().split("?v=").last;
    print('YOUTUBE VIDEO ID ============= ${id}');

    // youtubePlayerController = YoutubePlayerController(
    //   initialVideoId: "${id}",
    //   flags: YoutubePlayerFlags(),
    // );
    // youtubePlayerController?.setPlaybackRate(144.0);
    youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: id.toString(),
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true, loop: true),
    );
    // youtubePlayerController.
    // youtubePlayerController?.loadVideo(widget.data);
    // videoPlayer = VideoPlayerController.networkUrl(Uri.parse(widget.data))
    //   ..initialize().then((value) {
    //     videoPlayer.play();
    //   }).catchError((e) {
    //     print('ERORORRO==== $e');
    //   });
    // youtubePlayerController.
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    youtubePlayerController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      },
      child:
          // OrientationBuilder(builder: (context, orientation) {
          //   print('orientation $orientation');
          //   return
          //     YoutubePlayerScaffold(
          //     controller: youtubePlayerController!,
          //     // aspectRatio: 16 / 9,
          //     builder: (context, player) {
          //       return Stack(
          //         children: [
          //           orientation == Orientation.landscape
          //               ? SizedBox()
          //               : Positioned(
          //                   top: 0,
          //                   left: 0,
          //                   right: 0,
          //                   child: Container(
          //                     height: 150,
          //                     decoration: BoxDecoration(
          //                       // borderRadius: BorderRadius.only(
          //                       //   bottomLeft: Radius.circular(Responsive.height(3.5, context)),
          //                       //   bottomRight: Radius.circular(Responsive.height(3.5, context)),
          //                       // ),
          //                       gradient: LinearGradient(
          //                         begin: const FractionalOffset(0.0, 0.0),
          //                         end: const FractionalOffset(1.0, 0.0),
          //                         colors: [
          //                           Color(0xFF79e6c9).withOpacity(0.5),
          //                           Color(0xFF38b8cd).withOpacity(0.5),
          //                         ],
          //                         stops: [0.0, 1.0],
          //                       ),
          //                     ),
          //                     child: Padding(
          //                       padding:
          //                           EdgeInsets.only(bottom: 55, left: 20, top: 30),
          //                       child: Row(
          //                         // crossAxisAlignment: CrossAxisAlignment.end,
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         children: [
          //                           GestureDetector(
          //                             onTap: () {
          //                               print('tapppppppppppppppp');
          //                               SystemChrome.setPreferredOrientations(
          //                                       [DeviceOrientation.portraitUp])
          //                                   .then((_) {
          //                                 Navigator.of(context).pop(true);
          //                               });
          //                             },
          //                             child: Container(
          //                               padding: EdgeInsets.all(6),
          //                               decoration: BoxDecoration(
          //                                   borderRadius: BorderRadius.circular(10),
          //                                   color: Colors.black12),
          //                               child: Icon(Icons.arrow_back),
          //                             ),
          //                           ),
          //                           SizedBox(width: 15),
          //                           Expanded(
          //                             child: Text(
          //                               '${widget.title}',
          //                               style: AppTextStyle.appBarStyle
          //                                   .copyWith(fontSize: 18),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //
          //           orientation == Orientation.landscape
          //               ? Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 10.0, horizontal: 20),
          //                   child: Stack(
          //                     children: [
          //                       // VideoPlayer(videoPlayer),
          //                       YoutubePlayer(controller: youtubePlayerController!),
          //                       Positioned(
          //                         top: 0,
          //                         child: GestureDetector(
          //                           onTap: () {
          //                             SystemChrome.setPreferredOrientations(
          //                                 [DeviceOrientation.portraitUp]).then((_) {
          //                               Navigator.pop(context);
          //                             });
          //                           },
          //                           child: Icon(
          //                             Icons.arrow_back_ios_sharp,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 )
          //               : SizedBox(),
          //           player,
          //           // Text('Youtube Player'),
          //         ],
          //       );
          //     },
          //   );
          // }),
          Scaffold(body: OrientationBuilder(builder: (context, orientation) {
        // print('orientation $orientation');
        return Stack(
          children: [
            orientation == Orientation.landscape
                ? SizedBox()
                : Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //   bottomLeft: Radius.circular(Responsive.height(3.5, context)),
                        //   bottomRight: Radius.circular(Responsive.height(3.5, context)),
                        // ),
                        gradient: LinearGradient(
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          colors: [
                            Color(0xFF79e6c9).withOpacity(0.5),
                            Color(0xFF38b8cd).withOpacity(0.5),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 55, left: 20, top: 30),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('tapppppppppppppppp');
                                SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]).then((_) {
                                  Navigator.of(context).pop(true);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black12),
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                '${widget.title}',
                                style: AppTextStyle.appBarStyle
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            orientation == Orientation.landscape
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0),
                    child: Stack(
                      children: [
                        // VideoPlayer(videoPlayer),
                        // YoutubePlayer(controller: youtubePlayerController!),
                        YoutubePlayerScaffold(
                            builder: (context, player) {
                              return Column(
                                children: [
                                  player,
                                ],
                              );
                            },
                            controller: youtubePlayerController!),
                        Positioned(
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]).then((_) {});
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Positioned(
                    top: 100,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white),
                        //color: Colors.black12,
                        // color: Colors.grey[100],
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[100],
                        //   borderRadius: const BorderRadius.only(
                        //       topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        // ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.88,
                          // height: Responsive.height(100, context),
                          //padding: EdgeInsets.only(top: 10),
                          //color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 12, right: 10, top: 0, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        // AspectRatio(
                                        //     aspectRatio:
                                        //         videoPlayer.value.aspectRatio,
                                        //     child: VideoPlayer(videoPlayer)),
                                        YoutubePlayerScaffold(
                                            builder: (context, player) {
                                              return Column(
                                                children: [
                                                  player,
                                                ],
                                              );
                                            },
                                            controller:
                                                youtubePlayerController!)),
                                SizedBox(height: 20),
                                Text(
                                  "Description",
                                  style: AppTextStyle.titleStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${widget.desc}",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.disStyle
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        );
      })),
    );
  }
}
