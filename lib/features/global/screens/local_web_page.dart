import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalWebPage extends StatefulWidget {
  const LocalWebPage({super.key, required this.title, required this.htmlAsset});

  static Route route(String title, String htmlAsset) {
    return MaterialPageRoute<void>(
        builder: (_) => LocalWebPage(
              title: title,
              htmlAsset: htmlAsset,
            ));
  }

  final String title;
  final String htmlAsset;

  @override
  _LocalWebPageState createState() {
    return _LocalWebPageState();
  }
}

class _LocalWebPageState extends State<LocalWebPage> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();

    _controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) async {
        if (request.url.startsWith('file:') &&
            request.url.contains('flutter_assets')) {
          return NavigationDecision.navigate;
        }

        final uri = Uri.parse(request.url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }

        return NavigationDecision.prevent;
      },
    ));

    _controller.loadFlutterAsset(widget.htmlAsset);
  }

  @override
  Widget build(BuildContext context) {
    _controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dims.small),
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
