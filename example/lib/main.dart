import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:parallaxj/parallaxj.dart';
import "dart:math";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'parallaxj Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 400,
              child: Parallaxable(
                offsetRadio: 1.0 / 10,
                under: _underBackground(),
                above: _aboveBackground(),
              ),
            ),
          ),
          Center(child: SizedBox(width: 300, height: 300, child: Loading())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _underBackground() => const SizedBox(
        width: 200,
        height: 400,
        child: Padding(
          padding: EdgeInsets.only(top: 123),
          child: ColoredBox(
            color: Colors.redAccent,
          ),
        ),
      );

  _aboveBackground() => SizedBox(
      width: 200,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: Image.asset(
                  "images/ironman.png",
                  fit: BoxFit.fitWidth,
                )),
            const Text("钢铁侠（Iron "
                "Man）是美国漫威漫画旗下的超级英雄。有多代钢铁侠，其中最为著名的是托尼·史塔克，初次登场于《悬疑故事》第39期（1963年3月）,是斯塔克工业（STARK INDUSTRIES）的CEO")
          ],
        ),
      ));
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _aniController;

  @override
  void initState() {
    super.initState();
    _aniController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _aniController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black38,
      child: AnimatedBuilder(
        animation: _aniController,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: LoadingPainter(_aniController.value),
          );
        },
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final double progress;
  final double dosRadius = 9;
  final double gap = 0.1;
  final double dosNum = 6;
  final Color dosColor = Colors.yellow;
  late Paint _paint;

  LoadingPainter(this.progress) {
    _paint = Paint()
      ..color = dosColor
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // (x-a)^2+(y-b)^2=r^2
    // x,y = R*cos(θ) , R*sin(θ)
    // path of particle
    double minSide = min(size.width, size.height);
    double particle_radius = minSide / 2 - dosRadius;
    for (int i = 0; i < dosNum; i++) {
      double begin = 0.5 / (dosNum - 1) * i;
      /// 第一个结束 最后一个才开始 耗时都是 a
      ///
      var interval = Interval(begin, begin + 0.5, curve: Curves.slowMiddle);
      double angle = -pi / 2 + 2 * pi * interval.transform(progress);
      var offset =
          Offset(particle_radius * cos(angle), particle_radius * sin(angle));
      canvas.drawCircle(
          offset.translate(size.width / 2, size.height / 2), dosRadius, _paint);
    }
    // double angle = 2 * pi * progress;
    // var offset =
    //     Offset(particle_radius * cos(angle), particle_radius * sin(angle));
    // canvas.drawCircle(
    //     offset.translate(size.width / 2, size.height / 2), dosRadius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
