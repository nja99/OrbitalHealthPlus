import 'package:flutter/material.dart';

Widget buildLoadingOverlay(bool isLoading, Widget child) {
  return Stack(
    children: [
      child,
      if (isLoading)
        Positioned.fill(
          child: AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
    ],
  );
}
