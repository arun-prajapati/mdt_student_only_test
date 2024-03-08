import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../Constants/app_colors.dart';
import '../locater.dart';
import '../responsive/percentage_mediaquery.dart';
import '../responsive/size_config.dart';
import '../services/navigation_service.dart';
import '../widget/CustomAppBar.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final heading;

  WebViewContainer(this.url, this.heading);

  @override
  createState() => _WebViewContainerState(this.url, this.heading);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  bool isLoading = true;

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
            isLoading = false;
            setState(() {});
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
    print('_________________________--- ${_url}');

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = locator<NavigationService>();

    SizeConfig().init(context);
    return Scaffold(
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              preferedHeight: Responsive.height(10, context),
              iconLeft: Icons.arrow_back,
              title: heading,
              textWidth: Responsive.width(12, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
        ),*/
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
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBar(
              preferedHeight: Responsive.height(10, context),
              iconLeft: Icons.arrow_back,
              title: heading,
              textWidth: Responsive.width(12, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.125,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 3.2,
                      color: Dark,
                    ))
                  : WebViewWidget(
                      key: _key,
                      controller: _controller,
                    ),
            ),
          ),
        )
      ],
    ));
  }
}
