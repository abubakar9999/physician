import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/datasources/local_storage/boxes.dart';

class PlugInReportsPage extends StatefulWidget {
  const PlugInReportsPage({super.key});
  @override
  State<PlugInReportsPage> createState() => _PlugInReportsPageState();
}

class _PlugInReportsPageState extends State<PlugInReportsPage> with WidgetsBindingObserver {
  final databox = Boxes.allData();
  String cid = '';
  String userId = '';
  String userPassword = '';
  String plugin_url = '';
  String? deviceId = '';

  int progress = 0;
  late WebViewController controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _lastSuccessfulUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    cid = databox.get("CID") ?? '';
    userId = databox.get("user_id") ?? '';
    userPassword = databox.get("PASSWORD") ?? '';
    deviceId = databox.get("deviceId");
    plugin_url = databox.get("plugin_url") ?? '';

    _lastSuccessfulUrl = '$plugin_url?cid=$cid&user_id=$userId&user_pass=$userPassword';

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (mounted) {
                  setState(() {
                    this.progress = progress;
                  });
                }
              },

              onPageStarted: (String url) {
                log('onPageStarted: $url');
                if (mounted) {
                  setState(() {
                    progress = 0;
                    _isLoading = true;
                    _hasError = false;
                  });
                }
              },
              onPageFinished: (String url) {
                log('onPageFinished: $url');
                if (mounted) {
                  setState(() {
                    progress = 100;
                    _isLoading = false;
                    _lastSuccessfulUrl = url;
                  });
                }
              },
              onWebResourceError: (WebResourceError error) {
                log('onWebResourceError: URL: ${error.url}, Code: ${error.errorCode}, Description: ${error.description}');
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }

                if (error.errorCode == -2) {
                  log('onWebResourceError: Detected ERR_CACHE_MISS. Attempting to reload WebView.');
                  controller.reload();
                  Fluttertoast.showToast(msg: "reload again", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.orange, textColor: Colors.white);
                } else {
                  // Fluttertoast.showToast(
                  //   msg: "page reload failed: ${error.description}",
                  //   toastLength: Toast.LENGTH_LONG,
                  //   gravity: ToastGravity.BOTTOM,
                  //   backgroundColor: Colors.red,
                  //   textColor: Colors.white,
                  // );
                }
              },
              onNavigationRequest: (NavigationRequest request) async {
                final uri = Uri.parse(request.url);
                final scheme = uri.scheme;
                log('onNavigationRequest: Intercepted URL: $uri, Scheme: $scheme');

                if (scheme == 'intent') {
                  log('onNavigationRequest: Detected intent scheme. Attempting to launch externally.');
                  final String uriString = uri.toString();
                  final String fallbackUrlPrefix = 'S.browser_fallback_url=';
                  int startIndex = uriString.indexOf(fallbackUrlPrefix);

                  if (startIndex != -1) {
                    startIndex += fallbackUrlPrefix.length;
                    int endIndex = uriString.indexOf(';', startIndex);
                    if (endIndex == -1) {
                      endIndex = uriString.length;
                    }
                    String encodedFallbackUrl = uriString.substring(startIndex, endIndex);
                    String decodedFallbackUrl = Uri.decodeComponent(encodedFallbackUrl);
                    log('onNavigationRequest: Extracted fallback URL: $decodedFallbackUrl');
                    _launchUrlExternal(Uri.parse(decodedFallbackUrl));
                  } else {
                    _launchUrlExternal(uri);
                  }
                  return NavigationDecision.prevent;
                }

                if (scheme == 'https' && uri.host.contains('google.com') && uri.path.contains('maps')) {
                  log('onNavigationRequest: Detected HTTPS Google Maps URL. Attempting to launch externally.');
                  _launchUrlExternal(uri);
                  return NavigationDecision.prevent;
                }

                if (['http', 'https'].contains(scheme)) {
                  log('onNavigationRequest: Allowing internal navigation for scheme: $scheme');
                  return NavigationDecision.navigate;
                }

                log('onNavigationRequest: Attempting to launch general external URL for scheme: $scheme');
                _launchUrlExternal(uri);
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadRequest(Uri.parse(_lastSuccessfulUrl!));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _launchUrlExternal(Uri uri) async {
    try {
      bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        log('_launchUrlExternal: Successfully launched external URL: $uri');
      } else {
        log('_launchUrlExternal: Failed to launch external URL: $uri. No app found.');
        if (context.mounted) {
          Fluttertoast.showToast(msg: "found not app", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white);
        }
      }
    } catch (e) {
      log('_launchUrlExternal: Error launching external URL $uri: $e');
      if (context.mounted) {
        Fluttertoast.showToast(msg: "error: ${e.toString()}", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Initial WebView URL to load: $_lastSuccessfulUrl');

    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          title: const Text('Plug-In & Reports', style: TextStyle(color: Colors.white)),
          actions: [
            Row(
              children: <Widget>[
                // IconButton(
                //     onPressed: () async {
                //       if (await controller.canGoBack()) {
                //         await controller.goBack();
                //       } else {
                //         log("No Previous Page");
                //       }
                //       return;
                //     },
                //     icon: const Icon(Icons.arrow_back_ios)),
                // IconButton(
                //     onPressed: () async {
                //       if (await controller.canGoForward()) {
                //         await controller.goForward();
                //       } else {
                //         log("Last Page");
                //       }
                //       return;
                //     },
                //     icon: const Icon(Icons.arrow_forward_ios)),
                IconButton(
                  onPressed: () {
                    controller.reload();
                  },
                  icon: const Icon(Icons.replay),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            // if (_hasError)
            //   Center(
            //     child: Container(
            //       child: const Text(
            //         'Web page not available',
            //         style: TextStyle(fontSize: 18, color: Colors.red),
            //       ),
            //     ),
            //   )
            // else
            WebViewWidget(controller: controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (progress < 100) LinearProgressIndicator(backgroundColor: Colors.green, valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), value: progress / 100.0),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// import '../../data/datasources/local_storage/boxes.dart';
//
//
// class PlugInReportsPage extends StatefulWidget {
//   const PlugInReportsPage({
//     super.key,
//   });
//   @override
//   State<PlugInReportsPage> createState() => _PlugInReportsPageState();
// }
//
// class _PlugInReportsPageState extends State<PlugInReportsPage> {
//   late InAppWebViewController _webViewController;
//   double progress = 0;
//   final databox = Boxes.allData();
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//   String plugin_url = '';
//   String? deviceId = '';
//
//   @override
//   void initState() {
//     cid = databox.get("CID")!;
//     userId = databox.get("user_id")!;
//     userPassword = databox.get("PASSWORD")!;
//     plugin_url = databox.get("plugin_url") ?? '';
//     deviceId = databox.get("deviceId");
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('plugin report url:$plugin_url?cid=$cid&user_id=$userId&user_pass=$userPassword');
//     return WillPopScope(
//       onWillPop: () async {
//         if (await _webViewController.canGoBack()) {
//           _webViewController.goBack();
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Plug-In & Reports"),
//           leading: IconButton(
//               onPressed: () async {
//                 if (_webViewController != null &&
//                     await _webViewController!.canGoBack()) {
//                   _webViewController!.goBack();
//                 } else {
//                   Navigator.pop(context);
//                 }
//               },
//               icon: const Icon(Icons.arrow_back)),
//         ),
//         body: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
//                 child: InAppWebView(
//                   initialUrlRequest: URLRequest(
//                      // url: Uri.parse('$plugin_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&device_id=$deviceId')),
//                       url: WebUri('$plugin_url?cid=$cid&user_id=$userId&user_pass=$userPassword')),
//                   onWebViewCreated: (controller) {
//                     _webViewController = controller;
//                   },
//                   onReceivedServerTrustAuthRequest:
//                       (controller, challenge) async {
//                     // debugPrint(challenge);
//                     return ServerTrustAuthResponse(
//                         action: ServerTrustAuthResponseAction.PROCEED);
//                   },
//                   onProgressChanged:
//                       (InAppWebViewController controller, int progress) {
//                     setState(() {
//                       this.progress = progress / 100;
//                     });
//                   },
//                 ),
//               ),
//               Align(alignment: Alignment.topCenter, child: _buildProgressBar()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressBar() {
//     if (progress != 1.0) {
//       // return const CircularProgressIndicator();
// // You can use LinearProgressIndicator also
//       return LinearProgressIndicator(
//         value: progress,
//         valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
//         backgroundColor: Colors.blue,
//         minHeight: 7,
//       );
//     }
//     return Container();
//   }
// }
