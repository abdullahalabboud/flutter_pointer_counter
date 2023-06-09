import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: PointerCountPage(),
      ),
    );
  }
}

class PointerCountPage extends StatefulWidget {
  PointerCountPage({super.key});

  @override
  State<PointerCountPage> createState() => _PointerCountPageState();
}

class _PointerCountPageState extends State<PointerCountPage> {
  bool zoomable = false;
  final events = [];

  double xs = 0, ys = 0, xe = 0, ye = 0;
  var fingers = 0;

  void checkFingers({required var fingersCount}) {
    fingers = fingersCount;
    setState(() {});
  }

  // & select start points function
  void startPoints({required double x, required double y}) {
    xs = x;
    ys = y;
    xe = x;
    ye = y;
    setState(() {});
  }

  // & select last points function
  void lastPoints({required double x, required double y}) {
    xe = x;
    ye = y;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blueGrey,
      child: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Container(
            color: Colors.blue,
            child: InteractiveViewer(
              panEnabled: zoomable,
              child: Listener(
                onPointerUp: (event) {
                  events.clear();
                  setState(() {});
                },
                onPointerDown: (event) {
                  events.add(event.pointer);
                  if (events.length == 1) {
                    startPoints(
                        x: event.localPosition.dx, y: event.localPosition.dy);
                    zoomable = false;
                  } else if (events.length == 2) {
                    zoomable = true;
                  }
                  fingers = events.length;
                  print(events.length);

                  setState(() {});
                },
                onPointerMove: (event) {
                  if (events.length == 1) {
                    lastPoints(
                        x: event.localPosition.dx, y: event.localPosition.dy);
                    zoomable = false;
                  } else if (events.length == 2) {
                    zoomable = true;
                  }
                  setState(() {});
                },
                child: CustomPaint(
                  painter: SelectionPainter(
                    Rect.fromLTRB(xs, ys, xe, ye),
                  ),
                  child: Center(
                    child: Text(
                        "Fingers Count : ${fingers} \n events.length : ${events.length} \n start x :${xs.toStringAsFixed(2)} , start y :${ys.toStringAsFixed(2)} , end x :${xe.toStringAsFixed(2)} , end y :${ye.toStringAsFixed(2)} "),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// * CustomPaint class

class SelectionPainter extends CustomPainter {
  // * define space of painter (rect)
  Rect rect;
  // & contructor of selection painter .
  SelectionPainter(this.rect);

  // * define painter
  Paint painter = Paint()
    // ^ properties of paint
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  // * define canvas for painter of selection
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
