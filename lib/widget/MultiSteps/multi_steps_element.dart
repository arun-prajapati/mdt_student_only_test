import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';

class MultiStepsElements extends StatefulWidget {
  final List<String>? steps;
  final BoxConstraints? constraints;
  final BuildContext? parentContext;
  const MultiStepsElements(
      {Key? key, this.steps, this.constraints, this.parentContext})
      : super(key: key);

  @override
  MultiStepsElementsSate createState() => MultiStepsElementsSate();
}

// double barHeight = 95;
double tabWidth = 135;
double iconBlockArea = 45;
double iconHeight = 45;
const Color activeColor = Colors.black;
const Color inActiveColor = Colors.black26;
ScrollController _scrollController = ScrollController();

class MultiStepsElementsSate extends State<MultiStepsElements> {
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    GlobalKey widgetKey = GlobalKey();
    SizeConfig().init(context);
    tabWidth = Responsive.width(40, widget.parentContext!);
    iconBlockArea = Responsive.height(5, widget.parentContext!);
    iconHeight = iconBlockArea;
    return (SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: List.generate(widget.steps!.length, (index) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              transform: Matrix4.translationValues(
                  currentStep == 0 ? (-(tabWidth / 100) * 10) : 0, 0, 0.0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: tabWidth,
                          child: Row(
                            children: [
                              PipeLine(
                                  currentStep,
                                  (index == 0) ? false : true,
                                  (currentStep >= index)
                                      ? activeColor
                                      : inActiveColor),
                              CheckMark(currentStep, index),
                              PipeLine(
                                  currentStep,
                                  index == widget.steps!.length - 1
                                      ? false
                                      : true,
                                  (currentStep > index)
                                      ? activeColor
                                      : inActiveColor),
                            ],
                          )),
                      StepTitel(currentStep, widget.steps![index], index)
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    ));
  }

  void changeStep(int currentStep_index) {
    currentStep = currentStep_index;
    _scrollController.animateTo((tabWidth * currentStep),
        duration: Duration(milliseconds: 1000), curve: Curves.easeInOutSine);
  }

  Widget PipeLine(currentStep, _visibility, eventColor) {
    return (Container(
      width: (tabWidth / 2) - (iconBlockArea / 2),
      child: CustomPaint(
        size: Size((tabWidth / 2) - (iconBlockArea / 2), 0),
        painter: DrawLine(
            color: eventColor,
            width: (tabWidth / 2) - (iconBlockArea / 2),
            visibility: _visibility),
      ),
    ));
  }

  Widget CheckMark(currentStep, index) {
    return (Container(
      width: iconBlockArea,
      alignment: Alignment.center,
      child: FaIcon(FontAwesomeIcons.checkCircle,
          color: currentStep >= index ? activeColor : inActiveColor,
          size: iconHeight),
    ));
  }

  Widget StepTitel(currentStep, titel, index) {
    return (Container(
        width: tabWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: AutoSizeText(titel,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: currentStep >= index ? activeColor : inActiveColor,
                fontSize: 2 * SizeConfig.blockSizeVertical,
                fontWeight: FontWeight.w500))));
  }
}

class DrawLine extends CustomPainter {
  late Color? color;
  late double? width;
  late bool visibility = true;

  DrawLine({this.color, this.width, required this.visibility});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color!
      // ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = visibility ? 3 : 0;
    canvas.drawLine(Offset(visibility ? width! : 0, 0), Offset(0, 0), line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
