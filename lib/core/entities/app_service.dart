import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moniman/core/presentation/theme/app_color.dart';

class AppService extends Equatable {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? path;

  const AppService({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.path,
    this.color = AppColors.primary,
  });

  @override
  List<Object> get props => [title, subtitle, icon];
}
