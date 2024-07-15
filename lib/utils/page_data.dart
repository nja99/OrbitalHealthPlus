import 'package:flutter/material.dart';

class PageData {
  final Widget Function(Function(int) onCategorySelected, int currentIndex) pageBuilder;
  final String title;
  final bool showSearchBar;

  PageData({
    required this.pageBuilder,
    required this.title,
    this.showSearchBar = false,
  });
}