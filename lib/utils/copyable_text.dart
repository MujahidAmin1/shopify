import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  final String text;
  TextStyle? style;

  CopyableText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied: $text')),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: style
          ),
          const SizedBox(width: 6),
          const Icon(Icons.copy, size: 16, color: Colors.blue),
        ],
      ),
    );
  }
}
