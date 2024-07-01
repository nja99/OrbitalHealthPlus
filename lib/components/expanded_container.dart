import "package:flutter/material.dart";

class ExpandedContainer extends StatelessWidget {

  final Widget child;
  final EdgeInsetsDirectional padding;

  const ExpandedContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(0)
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50)
          )
        ),
        child: child
      )
    );
  }
}