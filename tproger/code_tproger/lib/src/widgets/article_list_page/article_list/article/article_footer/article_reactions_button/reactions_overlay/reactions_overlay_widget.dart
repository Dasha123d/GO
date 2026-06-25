import 'package:flutter/material.dart';

class ReactionsOverlayWidget extends StatelessWidget {
  const ReactionsOverlayWidget({ 
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: Container(
      height: 50,
      width: 200,
      color: Colors.green,
      child: const Text('+'),
    ),
  );
}
