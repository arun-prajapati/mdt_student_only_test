import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/locater.dart';
import 'package:student_app/responsive/percentage_mediaquery.dart';
import 'package:student_app/services/navigation_service.dart';
import 'package:student_app/widget/CustomAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Constants/app_colors.dart';
import '../responsive/size_config.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final heading;

  WebViewContainer(this.url, this.heading);
  @override
  createState() => _WebViewContainerState(this.url, this.heading);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  String heading;
  final _key = UniqueKey();
  late final WebViewController _controller;

  _WebViewContainerState(this._url, this.heading);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
            PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_url));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = locator<NavigationService>();

    SizeConfig().init(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              preferedHeight: Responsive.height(10, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              title: heading,
              textWidth: Responsive.width(12, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
        ),
        // AppBar(
        //   //automaticallyImplyLeading: true,
        //   iconTheme: IconThemeData(color: Colors.black),
        //   title: Text(
        //     heading,
        //     style: TextStyle(
        //         fontSize: SizeConfig.blockSizeHorizontal * 6,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.black
        //     ),
        //   ),
        //   elevation: 0.0,
        //   flexibleSpace: Container(
        //     decoration:  BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment(0.0, -1.0),
        //         end: Alignment(0.0, 1.0),
        //         colors: [Dark, Light],
        //         stops: [0.0, 1.0],
        //       ),
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                key: _key,
                controller: _controller,
              ),
            )
          ],
        ));
  }
}
