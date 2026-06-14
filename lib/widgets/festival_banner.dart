import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class FestivalBanner extends StatefulWidget {
  final PanchangamDay day;
  final String bannerType;
  final String? festivalName;

  const FestivalBanner({
    super.key,
    required this.day,
    required this.bannerType,
    this.festivalName,
  });

  @override
  State<FestivalBanner> createState() => _FestivalBannerState();
}

class _FestivalBannerState extends State<FestivalBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Gradient colours per festival
  static const Map<String, List<Color>> _gradients = {
    'normal':    [Color(0xFFC4520F), Color(0xFF9E3F08)],
    'diwali':    [Color(0xFF8B2500), Color(0xFF3D0A00)],
    'pongal':    [Color(0xFF0A5C1A), Color(0xFF063D10)],
    'karthigai': [Color(0xFF7A1A00), Color(0xFF3D0A00)],
    'chathurthi':[Color(0xFF8B5A00), Color(0xFF4A2E00)],
    'christmas': [Color(0xFF0A4A1A), Color(0xFF063010)],
    'ramjan':    [Color(0xFF0A1F4A), Color(0xFF050F28)],
    'krithikai': [Color(0xFF7A1A00), Color(0xFF3D0A00)],
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grads = _gradients[widget.bannerType] ?? _gradients['normal']!;
    final g0 = isDark ? grads[0].withOpacity(0.6) : grads[0];
    final g1 = isDark ? grads[1].withOpacity(0.8) : grads[1];

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [g0, g1],
            ),
          ),
          child: Stack(
            children: [
              // Festival animation layer
              Positioned.fill(
                child: CustomPaint(
                  painter: _FestivalPainter(
                    bannerType: widget.bannerType,
                    t: _ctrl.value,
                  ),
                ),
              ),
              // Panchangam content (always on top)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.day.weekdayTa,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 10,
                                    fontFamily: 'NotoSansTamil')),
                            Text(_dayNum(widget.day.date),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 44,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Inter', height: 1)),
                            Text('${_engMonth(widget.day.date)} · ${widget.day.tamilMonth}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12,
                                    fontFamily: 'NotoSansTamil',
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.day.tamilYear,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12,
                                    fontFamily: 'NotoSansTamil',
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('☀ ${widget.day.sunrise}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 10,
                                    fontFamily: 'Inter')),
                            Text('🌙 ${widget.day.sunset}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 10,
                                    fontFamily: 'Inter')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Timing strip
                    Row(
                      children: [
                        _Slot(label: 'நல்ல நேரம்',
                            time: '${widget.day.nallaNeramStart}–${widget.day.nallaNeramEnd}',
                            bg: Colors.white.withOpacity(0.20)),
                        const SizedBox(width: 5),
                        _Slot(label: 'ராகுகாலம்',
                            time: '${widget.day.rahukaalamStart}–${widget.day.rahukaalamEnd}',
                            bg: Colors.red.withOpacity(0.35),
                            textColor: const Color(0xFFFFB5A8)),
                        const SizedBox(width: 5),
                        _Slot(label: 'யமகண்டம்',
                            time: '${widget.day.yamakandamStart}–${widget.day.yamakandamEnd}',
                            bg: Colors.amber.withOpacity(0.30),
                            textColor: const Color(0xFFFFE09A)),
                      ],
                    ),
                  ],
                ),
              ),
              // Festival wish overlay
              if (widget.festivalName != null)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(widget.festivalName!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'NotoSansTamil',
                              shadows: [Shadow(blurRadius: 4, color: Colors.black38)])),
                      const Text('வாழ்த்துகள்!',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 10,
                              fontFamily: 'NotoSansTamil')),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _dayNum(String date) => date.split('-')[2];
  String _engMonth(String date) {
    const months = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[int.parse(date.split('-')[1])]} ${date.split('-')[0]}';
  }
}

class _Slot extends StatelessWidget {
  final String label;
  final String time;
  final Color bg;
  final Color textColor;

  const _Slot({
    required this.label,
    required this.time,
    required this.bg,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: textColor.withOpacity(0.85),
                    fontSize: 7,
                    fontFamily: 'NotoSansTamil',
                    fontWeight: FontWeight.w500)),
            Text(time,
                style: TextStyle(
                    color: textColor,
                    fontSize: 9,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ── CustomPainter for festival animations ────────────────────────────────────
class _FestivalPainter extends CustomPainter {
  final String bannerType;
  final double t; // 0..1 animation tick

  _FestivalPainter({required this.bannerType, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    switch (bannerType) {
      case 'diwali':    _drawDiwali(canvas, size, t);    break;
      case 'pongal':    _drawPongal(canvas, size, t);    break;
      case 'karthigai': _drawKarthigai(canvas, size, t); break;
      case 'chathurthi':_drawChathurthi(canvas, size, t);break;
      case 'christmas': _drawChristmas(canvas, size, t); break;
      case 'ramjan':    _drawRamjan(canvas, size, t);    break;
      case 'krithikai': _drawKrithikai(canvas, size, t); break;
      default: break;
    }
  }

  // ── Diwali: oil lamps + fireworks ──────────────────────────────────────────
  void _drawDiwali(Canvas c, Size s, double t) {
    // Bottom lamps
    for (int i = 0; i < 6; i++) {
      _lamp(c, 16.0 + i * 38, s.height - 30, t, i * 0.3);
    }
    // Sparks top corners
    _sparks(c, 40, 30, t, [const Color(0xFFFFD700), const Color(0xFFFF6B00)]);
    _sparks(c, s.width - 40, 25, t + 0.5, [const Color(0xFFFFD700), const Color(0xFFFF99CC)]);
    _sparks(c, s.width / 2, 20, t + 0.3, [const Color(0xFFFFD700), Colors.white]);
  }

  void _lamp(Canvas c, double x, double y, double t, double phase) {
    final flicker = 0.8 + 0.2 * math.sin(t * math.pi * 6 + phase);
    final basePaint = Paint()..color = const Color(0xFF785020).withOpacity(0.88);
    c.drawOval(Rect.fromCenter(center: Offset(x, y), width: 16, height: 8), basePaint);
    // Flame
    final flamePath = Path()
      ..moveTo(x, y - 11 * flicker)
      ..quadraticBezierTo(x + 5, y - 6, x + 3, y)
      ..quadraticBezierTo(x, y - 3, x - 3, y)
      ..quadraticBezierTo(x - 5, y - 6, x, y - 11 * flicker);
    c.drawPath(flamePath, Paint()..color = const Color(0xFFFFD000));
    final innerPath = Path()
      ..moveTo(x, y - 8 * flicker)
      ..quadraticBezierTo(x + 3, y - 5, x + 2, y - 1)
      ..quadraticBezierTo(x, y - 3, x - 2, y - 1)
      ..quadraticBezierTo(x - 3, y - 5, x, y - 8 * flicker);
    c.drawPath(innerPath, Paint()..color = const Color(0xFFFF8C00));
  }

  void _sparks(Canvas c, double cx, double cy, double t, List<Color> colors) {
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi * 2 + t * math.pi;
      final prog = ((t * 0.8 + i * 0.25) % 1.5);
      final dist = prog * 25;
      final alpha = math.max(0.0, 1.0 - prog / 1.5);
      final p = Paint()..color = colors[i % colors.length].withOpacity(alpha);
      c.drawCircle(
          Offset(cx + math.cos(angle) * dist, cy + math.sin(angle) * dist),
          2.5 * (1 - prog * 0.5), p);
    }
  }

  // ── Pongal: pot with steam + sugar cane ────────────────────────────────────
  void _drawPongal(Canvas c, Size s, double t) {
    _cane(c, 16, s.height, t, 0);
    _cane(c, 28, s.height, t, 0.5);
    // Mirror right side
    c.save();
    c.scale(-1, 1);
    c.translate(-s.width, 0);
    _cane(c, 16, s.height, t, 0.2);
    _cane(c, 28, s.height, t, 0.7);
    c.restore();
    _pot(c, s.width / 2, 100, t);
  }

  void _cane(Canvas c, double x, double h, double t, double phase) {
    final lean = 0.05 * math.sin(t * math.pi * 3 + phase);
    c.save();
    c.translate(x, h);
    c.rotate(lean);
    final paint = Paint()
      ..color = const Color(0xFF22781E).withOpacity(0.65)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(5, -80, 2, -155);
    c.drawPath(path, paint);
    c.restore();
  }

  void _pot(Canvas c, double cx, double cy, double t) {
    c.save();
    c.translate(cx, cy);
    // Body
    final body = Paint()..color = const Color(0xFF9B4614).withOpacity(0.88);
    final path = Path()
      ..moveTo(-18, -18)
      ..quadraticBezierTo(-24, 2, -20, 30)
      ..lineTo(20, 30)
      ..quadraticBezierTo(24, 2, 18, -18)
      ..close();
    c.drawPath(path, body);
    // Rim
    c.drawOval(
        Rect.fromCenter(center: const Offset(0, -18), width: 38, height: 14),
        Paint()..color = const Color(0xFFBE551E).withOpacity(0.9));
    // Pongal
    c.drawOval(
        Rect.fromCenter(center: const Offset(0, -21), width: 30, height: 16),
        Paint()..color = const Color(0xFFEBC34A).withOpacity(0.88));
    // Steam wisps
    for (int i = 0; i < 3; i++) {
      final prog = ((t * 0.6 + i * 0.33) % 1.0);
      final sx = (i - 1) * 7.0;
      final sy = -28 - prog * 28;
      final alpha = math.sin(prog * math.pi) * 0.5;
      final sp = Paint()
        ..color = Colors.white.withOpacity(alpha)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final sp2 = Path()
        ..moveTo(sx, sy + 28)
        ..quadraticBezierTo(sx + 6, sy + 14, sx, sy);
      c.drawPath(sp2, sp);
    }
    c.restore();
  }

  // ── Karthigai: Vel + bottom lamps ──────────────────────────────────────────
  void _drawKarthigai(Canvas c, Size s, double t) {
    for (int i = 0; i < 11; i++) {
      _lamp(c, 12.0 + i * 20, s.height - 18, t, i * 0.28);
    }
    _vel(c, s.width / 2, 75, t);
  }

  void _vel(Canvas c, double cx, double cy, double t) {
    final glow = 0.55 + 0.2 * math.sin(t * math.pi * 4);
    c.save();
    c.translate(cx, cy);
    // Glow halo
    c.drawCircle(Offset.zero, 28,
        Paint()..color = const Color(0xFFFFC864).withOpacity(0.18 * glow)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    // Blade
    final blade = Path()
      ..moveTo(0, -42)
      ..lineTo(8, -8)
      ..lineTo(0, 2)
      ..lineTo(-8, -8)
      ..close();
    c.drawPath(blade,
        Paint()..color = const Color(0xFFFFDB5A).withOpacity(0.82 + 0.12 * math.sin(t * math.pi * 4)));
    // Handle
    c.drawLine(const Offset(0, 2), const Offset(0, 44),
        Paint()
          ..color = const Color(0xFFC89637).withOpacity(0.82)
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round);
    c.restore();
  }

  // ── Chathurthi: Ganesha silhouette + modaks ────────────────────────────────
  void _drawChathurthi(Canvas c, Size s, double t) {
    _ganesha(c, s.width / 2, 90, t);
    _modak(c, 25, 50, t, 0);
    _modak(c, s.width - 25, 55, t, 1.2);
    _modak(c, 22, 120, t, 0.8);
    _modak(c, s.width - 22, 115, t, 2.0);
  }

  void _ganesha(Canvas c, double cx, double cy, double t) {
    final bob = 3 * math.sin(t * math.pi * 2.4);
    c.save();
    c.translate(cx, cy + bob);
    // Body
    c.drawOval(
        Rect.fromCenter(center: const Offset(0, 22), width: 44, height: 56),
        Paint()..color = const Color(0xFFF8C44C).withOpacity(0.75));
    // Head
    c.drawOval(
        Rect.fromCenter(center: const Offset(0, -8), width: 40, height: 40),
        Paint()..color = const Color(0xFFF8D062).withOpacity(0.85));
    // Ears
    c.drawOval(
        Rect.fromCenter(center: const Offset(-21, -6), width: 26, height: 34),
        Paint()..color = const Color(0xFFF5BE3A).withOpacity(0.68));
    c.drawOval(
        Rect.fromCenter(center: const Offset(21, -6), width: 26, height: 34),
        Paint()..color = const Color(0xFFF5BE3A).withOpacity(0.68));
    // Crown
    final crown = Path()
      ..moveTo(-11, -26)
      ..lineTo(0, -42)
      ..lineTo(11, -26)
      ..close();
    c.drawPath(crown, Paint()..color = const Color(0xFFF8A000).withOpacity(0.9));
    // Eyes
    c.drawCircle(const Offset(-6, -12), 3, Paint()..color = const Color(0xFF2D1200).withOpacity(0.9));
    c.drawCircle(const Offset(6, -12), 3, Paint()..color = const Color(0xFF2D1200).withOpacity(0.9));
    // Trunk
    final trunkPath = Path()
      ..moveTo(0, -4)
      ..quadraticBezierTo(17, 5, 11, 22);
    c.drawPath(trunkPath,
        Paint()
          ..color = const Color(0xFFC39628).withOpacity(0.85)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
    c.restore();
  }

  void _modak(Canvas c, double x, double y, double t, double phase) {
    final fl = 0.45 + 0.3 * math.sin(t * math.pi * 3.2 + phase);
    final dy = 4 * math.sin(t * math.pi * 2 + phase);
    c.save();
    c.translate(x, y + dy);
    final path = Path()
      ..moveTo(0, -11)
      ..quadraticBezierTo(9, -4, 8, 8)
      ..quadraticBezierTo(0, 14, -8, 8)
      ..quadraticBezierTo(-9, -4, 0, -11);
    c.drawPath(path, Paint()..color = const Color(0xFFFFE69E).withOpacity(fl));
    c.restore();
  }

  // ── Christmas: snowflakes + star ───────────────────────────────────────────
  void _drawChristmas(Canvas c, Size s, double t) {
    _christmasStar(c, s.width / 2, 22, t);
    final flakes = [
      [18.0, 32.0, 0.58, 0.0], [52.0, 58.0, 0.42, 1.2],
      [88.0, 22.0, 0.5, 2.1], [148.0, 44.0, 0.6, 0.5],
      [182.0, 16.0, 0.4, 1.8], [214.0, 52.0, 0.48, 3.0],
    ];
    for (final f in flakes) {
      _snowflake(c, f[0], (f[1] + t * 14 * f[2]) % s.height, f[2], t + f[3]);
    }
    _holly(c, 15, s.height - 38, t);
    _holly(c, s.width - 15, s.height - 38, t);
  }

  void _christmasStar(Canvas c, double cx, double cy, double t) {
    final glow = 0.72 + 0.2 * math.sin(t * math.pi * 4);
    c.save();
    c.translate(cx, cy);
    c.rotate(t * math.pi);
    const pts = 5; const outer = 15.0; const inner = 6.0;
    final path = Path();
    for (int i = 0; i < pts * 2; i++) {
      final r = i % 2 == 0 ? outer : inner;
      final a = (i * math.pi) / pts - math.pi / 2;
      final p = Offset(r * math.cos(a), r * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    c.drawPath(path, Paint()..color = const Color(0xFFFFDA30).withOpacity(glow));
    c.restore();
  }

  void _snowflake(Canvas c, double x, double y, double scale, double t) {
    final alpha = 0.38 + 0.28 * math.sin(t * math.pi * 4);
    final p = Paint()
      ..color = const Color(0xFFC3E1FF).withOpacity(alpha)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    c.save();
    c.translate(x, y);
    c.scale(scale, scale);
    for (int i = 0; i < 6; i++) {
      c.save();
      c.rotate(i * math.pi / 3);
      c.drawLine(Offset.zero, const Offset(0, -9), p);
      c.drawLine(const Offset(0, -4.5), const Offset(3.5, -7), p);
      c.drawLine(const Offset(0, -4.5), const Offset(-3.5, -7), p);
      c.restore();
    }
    c.restore();
  }

  void _holly(Canvas c, double x, double y, double t) {
    c.save();
    c.translate(x, y);
    c.rotate(0.1 * math.sin(t * math.pi * 2));
    c.drawOval(Rect.fromCenter(center: const Offset(-8, 0), width: 18, height: 9),
        Paint()..color = const Color(0xFF1C871C).withOpacity(0.72));
    c.drawOval(Rect.fromCenter(center: const Offset(8, 0), width: 18, height: 9),
        Paint()..color = const Color(0xFF1C871C).withOpacity(0.72));
    for (final p in [const Offset(-3, -5), const Offset(0, -7), const Offset(3, -5)]) {
      c.drawCircle(p, 3.2, Paint()..color = const Color(0xFFD71C1C).withOpacity(0.88));
    }
    c.restore();
  }

  // ── Ramzan: crescent moon + lanterns ───────────────────────────────────────
  void _drawRamjan(Canvas c, Size s, double t) {
    _islamicPattern(c, s, t);
    _crescent(c, s.width - 45, 35, t);
    _lantern(c, 28, 50, t, 0);
    _lantern(c, s.width - 28, 50, t, 1.2);
  }

  void _islamicPattern(Canvas c, Size s, double t) {
    final p = Paint()
      ..color = const Color(0xFFC3B44E).withOpacity(0.07 + 0.015 * math.sin(t * math.pi * 2))
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    const step = 22.0;
    for (double xi = 0; xi < s.width; xi += step) {
      for (double yi = 0; yi < s.height; yi += step) {
        final path = Path()
          ..moveTo(xi + step / 2, yi)
          ..lineTo(xi + step, yi + step / 2)
          ..lineTo(xi + step / 2, yi + step)
          ..lineTo(xi, yi + step / 2)
          ..close();
        c.drawPath(path, p);
      }
    }
  }

  void _crescent(Canvas c, double cx, double cy, double t) {
    final pulse = 0.78 + 0.16 * math.sin(t * math.pi * 3);
    c.save();
    c.translate(cx, cy);
    c.drawCircle(Offset.zero, 21, Paint()..color = const Color(0xFFFFD44E).withOpacity(0.15 * pulse));
    c.drawCircle(Offset.zero, 15, Paint()..color = const Color(0xFFFFD44E).withOpacity(0.82 * pulse));
    c.drawCircle(const Offset(5, -3), 12,
        Paint()..color = const Color(0xFF00041C).withOpacity(0.96));
    // Star
    c.save();
    c.translate(14, -13);
    final starPath = Path();
    for (int i = 0; i < 10; i++) {
      final r = i % 2 == 0 ? 5.0 : 2.0;
      final a = (i * math.pi) / 5 - math.pi / 2;
      final p = Offset(r * math.cos(a), r * math.sin(a));
      i == 0 ? starPath.moveTo(p.dx, p.dy) : starPath.lineTo(p.dx, p.dy);
    }
    starPath.close();
    c.drawPath(starPath, Paint()..color = const Color(0xFFFFD44E).withOpacity(0.9 * pulse));
    c.restore();
    c.restore();
  }

  void _lantern(Canvas c, double cx, double cy, double t, double phase) {
    c.save();
    c.translate(cx, cy);
    c.rotate(0.08 * math.sin(t * math.pi * 1.6 + phase));
    final glow = 0.68 + 0.16 * math.sin(t * math.pi * 6 + phase);
    // String
    c.drawLine(Offset(0, -cy * 0.55), const Offset(0, -11),
        Paint()..color = const Color(0xFF947630).withOpacity(0.5)..strokeWidth = 1);
    // Body
    c.drawRect(const Rect.fromLTWH(-8, -11, 16, 26),
        Paint()..color = const Color(0xFFD74B1C).withOpacity(glow * 0.82));
    // Inner glow
    c.drawRect(const Rect.fromLTWH(-5, -7, 10, 18),
        Paint()..color = const Color(0xFFFFC64B).withOpacity(glow * 0.38));
    // Caps
    c.drawRect(const Rect.fromLTWH(-9, -13, 18, 4),
        Paint()..color = const Color(0xFFAF761C).withOpacity(0.82));
    c.drawRect(const Rect.fromLTWH(-9, 15, 18, 4),
        Paint()..color = const Color(0xFFAF761C).withOpacity(0.82));
    c.restore();
  }

  // ── Krithikai: Vel + 6 stars + peacock feathers ───────────────────────────
  void _drawKrithikai(Canvas c, Size s, double t) {
    const angles = [0.0, 60.0, 120.0, 180.0, 240.0, 300.0];
    for (int i = 0; i < 6; i++) {
      final rad = angles[i] * math.pi / 180;
      final sx = s.width / 2 + 52 * math.cos(rad - math.pi / 2);
      final sy = 82 + 38 * math.sin(rad - math.pi / 2);
      _twinkleStar(c, sx, sy, t, i * 0.52);
    }
    _vel(c, s.width / 2, 88, t);
    _peacockFeather(c, 16, 80, t, 0);
    _peacockFeather(c, s.width - 16, 80, t, 1.0);
  }

  void _twinkleStar(Canvas c, double x, double y, double t, double phase) {
    final alpha = 0.38 + 0.52 * (math.sin(t * math.pi * 5.2 + phase)).abs();
    final scale = 0.55 + 0.42 * (math.sin(t * math.pi * 5.2 + phase)).abs();
    c.save();
    c.translate(x, y);
    c.scale(scale, scale);
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final r = i % 2 == 0 ? 6.0 : 2.5;
      final a = (i * math.pi) / 4 - math.pi / 4;
      final p = Offset(r * math.cos(a), r * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    c.drawPath(path, Paint()..color = const Color(0xFFFFDA62).withOpacity(alpha));
    c.restore();
  }

  void _peacockFeather(Canvas c, double x, double y, double t, double phase) {
    c.save();
    c.translate(x, y);
    c.rotate(0.1 * math.sin(t * math.pi * 3 + phase));
    final stem = Paint()
      ..color = const Color(0xFF2DAC5F).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, 48)
      ..quadraticBezierTo(4, 12, 0, -28);
    c.drawPath(path, stem);
    // Eye
    c.drawOval(Rect.fromCenter(center: const Offset(0, -28), width: 14, height: 20),
        Paint()..color = const Color(0xFF005FC3).withOpacity(0.5));
    c.drawOval(Rect.fromCenter(center: const Offset(0, -28), width: 9, height: 14),
        Paint()..color = const Color(0xFF00AF5F).withOpacity(0.6));
    c.drawOval(Rect.fromCenter(center: const Offset(0, -28), width: 5, height: 9),
        Paint()..color = const Color(0xFF00004B).withOpacity(0.82));
    c.restore();
  }

  @override
  bool shouldRepaint(_FestivalPainter old) =>
      old.bannerType != bannerType || old.t != t;
}
