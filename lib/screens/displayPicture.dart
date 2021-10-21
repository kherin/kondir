import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:basic_utils/basic_utils.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String rightAnswer;

  const DisplayPictureScreen({
    Key key,
    this.imagePath,
    this.rightAnswer,
  }) : super(key: key);

  String transformLabel(String label) {
    var removedUnderScore = label.replaceAll("_", " ");
    return StringUtils.capitalize(removedUnderScore);
  }

  void verifyIfRightAnswer(String value, BuildContext context) {
    var msg = "Wrong Answer";
    if (this.transformLabel(this.rightAnswer) == value) {
      msg = "Right Answer";
    }
    final snackBar = SnackBar(
      content: Text(msg),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var randomGenerator = new Random();
    var selectedOptionLabels = [];
    const optionLabels = [
      "20_speed",
      "30_speed",
      "50_speed",
      "60_speed",
      "70_speed",
      "80_speed",
      "80_lifted",
      "100_speed",
      "120_speed",
      "no_overtaking_general",
      "no_overtaking_trucks",
      "right_of_way_crossing",
      "right_of_way_general",
      "give_way",
      "stop",
      "no_way_general",
      "no_way_trucks",
      "no_way_one_way",
      "attention_general",
      "attention_left_turn",
      "attention_right_turn",
      "attention_curvy",
      "attention_bumpers",
      "attention_slippery",
      "attention_bottleneck",
      "attention_construction",
      "attention_traffic_light",
      "attention_pedestrian",
      "attention_children",
      "attention_bikes",
      "attention_snowflake",
      "attention_deer",
      "lifted_general",
      "turn_right",
      "turn_left",
      "turn_straight",
      "turn_straight_right",
      "turn_straight_left",
      "turn_right_down",
      "turn_left_down",
      "turn_circle",
      "lifted_no_overtaking_general",
      "lifted_no_overtaking_trucks"
    ];

    for (var index = 0; index < 3; index++) {
      var labelPosition = randomGenerator.nextInt(optionLabels.length - 1);
      selectedOptionLabels.add(transformLabel(optionLabels[labelPosition]));
    }

    if (rightAnswer != null) {
      selectedOptionLabels.add(transformLabel(rightAnswer));
    } else {
      print("Right answer is null");
    }
    // var parsedOptionLabels = optionLabels.
    var options = <Widget>[];

    for (var label in selectedOptionLabels) {
      Widget option = Column(children: <Widget>[
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ), //SizedBox
            Text(
              label,
              style: TextStyle(fontSize: 20),
            ), //Text
            SizedBox(width: 10), //SizedBox
            /** Checkbox Widget **/
            Checkbox(
              value: false,
              onChanged: (value) {
                verifyIfRightAnswer(label, context);
              },
            ), //Checkbox
          ], //<Widget>[]
        ), //Row
      ]);

      options.add(option);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identify the Traffic Sign'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Image.file(
              File(imagePath),
              height: 400,
            ),
          ),
          Text(
            'Which traffic sign is it ?',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          Column(
            children: options,
          ), //Column
        ],
      ),
    );
  }
}
