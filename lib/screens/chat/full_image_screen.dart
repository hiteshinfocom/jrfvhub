import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {

  final String imageUrl;

  const FullImageScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
      ),

      body: Center(

        child: InteractiveViewer(

          minScale: 0.5,
          maxScale: 5,

          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}