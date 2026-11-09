import 'package:flutter/material.dart';

Widget newsMessage(String message, {VoidCallback? retry}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (retry != null)
            TextButton(onPressed: retry, child: const Text('Try Again')),
        ],
      ),
    ),
  );
}
