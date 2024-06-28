import 'package:flutter/material.dart';

class PageData {
  final Widget page;
  final String title;
  final bool showSearchBar;

  PageData({
    required this.page, 
    required this.title,
    this.showSearchBar = false
  });
}