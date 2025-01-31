import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class FluidFillIconData {
  final List<ui.Path> paths;
  FluidFillIconData(this.paths);
}

class FluidFillIcons {
  // 홈 아이콘
  static final home = FluidFillIconData([
    ui.Path()..addRRect(RRect.fromLTRBXY(-10, -2, 10, 10, 2, 2)),  // 사각형 형태의 집 모양
    ui.Path()..moveTo(-14, -2)..lineTo(14, -2)..lineTo(0, -16)..close(),  // 집 지붕 모양
  ]);

  // 검색 아이콘
  static final search = FluidFillIconData([
    ui.Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 10)),  // 원 형태
    ui.Path()..moveTo(6, 6)..lineTo(12, 12),  // 확대경 손잡이
  ]);

  // 책장 아이콘 (변경된 모양)
  static final bookshelf = FluidFillIconData([
    ui.Path()..addRRect(RRect.fromLTRBXY(-10, -10, 10, 10, 4, 4)),  // 책장 외곽
    ui.Path()..moveTo(-10, -4)..lineTo(10, -4),  // 책장 상단
    ui.Path()..moveTo(-10, 4)..lineTo(10, 4),    // 책장 하단
    ui.Path()..moveTo(-10, -2)..lineTo(-10, 6),   // 첫 번째 책
    ui.Path()..moveTo(0, -2)..lineTo(0, 6),       // 두 번째 책
    ui.Path()..moveTo(10, -2)..lineTo(10, 6),     // 세 번째 책
  ]);

  // 옵션 아이콘 (변경된 모양)
  static final options = FluidFillIconData([
    ui.Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 8)),  // 원 형태
    ui.Path()..moveTo(0, -4)..lineTo(0, -6),  // 첫 번째 점
    ui.Path()..moveTo(0, 0)..lineTo(0, -2),  // 두 번째 점
    ui.Path()..moveTo(0, 4)..lineTo(0, 6),   // 세 번째 점
  ]);
}