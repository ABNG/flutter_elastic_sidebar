import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double width;
  double height;
  double sidebar;
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  double menuContainerHeight;
  List<double> limits = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      final position = renderBox.localToGlobal(Offset.zero);
      double start = position.dy - 20;
      double end = position.dy + renderBox.size.height - 20;
      double step = (end - start) / 5;
      limits = [];
      for (double x = start; x <= end + 0.1; x = x + step) {
        print("x: $x , end: $end");
        limits.add(x);
      }
      print(limits.length);
      setState(() {
        limits = limits;
      });
    });
  }

  double getSize(int x) {
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    sidebar = width * 0.65;
    menuContainerHeight = height / 2;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: width,
          height: height,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: sidebar,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              if (details.localPosition.dx <= sidebar)
                setState(() {
                  _offset = details.localPosition;
                });
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                _offset = Offset.zero;
              });
            },
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(sidebar, height),
                  painter: MyCustomPaint(_offset),
                ),
                Container(
                  height: height,
                  width: sidebar,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: height * 0.25,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/dp_default.png",
                                width: sidebar / 2,
                                height: height * 0.20,
                              ),
                              Text(
                                "RetroPortal Studio",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Container(
                        key: globalKey,
                        width: double.infinity,
                        height: menuContainerHeight,
                        child: Column(
                          children: <Widget>[
                            MyButton(
                              text: "Profile",
                              iconData: Icons.person,
                              textSize: getSize(0),
                              height: (menuContainerHeight) / 5,
                            ),
                            MyButton(
                              text: "Payments",
                              iconData: Icons.payment,
                              textSize: getSize(1),
                              height: (menuContainerHeight) / 5,
                            ),
                            MyButton(
                              text: "Notifications",
                              iconData: Icons.notifications,
                              textSize: getSize(2),
                              height: (menuContainerHeight) / 5,
                            ),
                            MyButton(
                              text: "Settings",
                              iconData: Icons.settings,
                              textSize: getSize(3),
                              height: (menuContainerHeight) / 5,
                            ),
                            MyButton(
                              text: "My Files",
                              iconData: Icons.attach_file,
                              textSize: getSize(4),
                              height: (menuContainerHeight) / 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MyCustomPaint extends CustomPainter {
  final Offset position;
  MyCustomPaint(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    print(position.dy);
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getPositionX(size.width), position.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  double getPositionX(double width) {
    if (position.dx == 0) {
      return width;
    } else {
      return position.dx > width ? position.dx : width + 75;
    }
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;

  MyButton({this.text, this.iconData, this.textSize, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black45, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
