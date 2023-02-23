import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:real_stepper/real_stepper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RealStepperController stepperController = RealStepperController();
  GlobalKey<FormState> form1 = GlobalKey();
  String? error;
  String settings = '';

  checkForErrors() {
    if (form1.currentState?.validate() ?? false) {
      setState(() {
        error = null;
      });
    } else {
      setState(() {
        error = '';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<RealStep> getSteps() {
    return [
      RealStep(
          titleText: 'Home',
          icon: Icon(Icons.home),
          content: Center(
            child: Image.network('https://picsum.photos/400/350'),
          )),
      RealStep(
          error: '',
          titleText: 'Security',
          icon: Icon(Icons.security),
          content: Form(
            key: form1,
            autovalidateMode: AutovalidateMode.disabled,
            child: Center(
              child: Image.network('https://picsum.photos/350/300'),
            ),
          )),
      RealStep(
        titleText: 'Search',
        content: Center(
          child: Image.network('https://picsum.photos/400/200'),
        ),
        icon: Icon(Icons.search),
      ),
      RealStep(
          titleText: 'Alarm',
          content: Center(
            child: Image.network('https://picsum.photos/300/200'),
          ),
          icon: Icon(Icons.alarm),
          disabled: true),
      RealStep(
          icon: Icon(Icons.account_box),
          title: Text(
            'Account',
            style: TextStyle(color: Colors.blue),
          ),
          content: Center(
            child: Image.network('https://picsum.photos/400/300'),
          )),
      RealStep(
          icon: Icon(Icons.sailing),
          titleText: 'Sailing',
          content: Center(
            child: Image.network('https://picsum.photos/200/300'),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    checkForErrors();
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Real Stepper example app'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 400,
                child: RealStepper(
                  hideActionButtons: false,
                  // disableAutoScroll: true,
                  controller: stepperController,
                  onStepChanged: (status, previousIndex, index) {
                    print('$previousIndex -> $index - Status: $status');
                  },
                  lineLength: 60,
                  stepContainerWrapperPadding: EdgeInsets.all(4),
                  steps: getSteps(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            stepperController.animatePrevious();
                          },
                          child: Text('Previous')),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            stepperController.animateNext();
                          },
                          child: Text('Next')),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        stepperController.animateToStart();
                      },
                      child: Text('Start')),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        stepperController.animateToEnd();
                      },
                      child: Text('End')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
