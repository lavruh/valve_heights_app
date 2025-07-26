import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/help.md'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data == null) return Text('...');
          return SingleChildScrollView(child: MarkdownBlock(data: data));
        }
        return Text('...');
      },
    );
  }
}
