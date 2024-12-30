import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<int> totalPoints = 0.obs;
  Rx<int> totalLives = 3.obs;
  String question = '';
  Rx<int> answerCorrect = 0.obs;
  RxString rightAnswer = ''.obs;
  Timer? timer;
  Rx<int> timeLeft = 10.obs;
  TextEditingController correctAmount = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    generateNewQuestion();
    startTimer();
  }

  Future<void> startTimer() async {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }

    // Start a new periodic timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
        update();
      } else {
        handleWrongAnswer();
      }
    });
  }

  // get Container Height Function//
  double getContainerHeight() {
    return 150 + (10 - timeLeft.value) * 30;
  }

  // get Color Based On Time Function //
  Color getColorBasedOnTime() {
    double red = 255;
    double green = 255 - ((255 - 105) * (10 - timeLeft.value) / 10);
    double blue = 255 - ((255 - 180) * (10 - timeLeft.value) / 10);

    return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1.0);
  }

  Future<void> resetTimer() async {
    print("Resetting timer...");
    timer?.cancel();
    timeLeft.value = 10;
    displayValue.value = '';

    await startTimer();

    update();
  }

  // generate New Question Function //
  void generateNewQuestion() {
    Random random = Random();
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    List<String> operators = ['+', 'X'];
    String operator = operators[random.nextInt(2)];

    switch (operator) {
      case '+':
        answerCorrect.value = num2 + num1;
        break;
      case 'X':
        answerCorrect.value = num2 * num1;
        break;
    }

    question = '$num1 $operator $num2';
    rightAnswer.value = '';
    update();
  }

  // check Answer Right Or Wrong Function //
  void checkAnswerRightOrWrong() {
    if (int.tryParse(rightAnswer.value) == answerCorrect.value) {
      totalPoints.value++;
      correctAmount.clear();
      generateNewQuestion();
      resetTimer();
      update();
    } else {
      handleWrongAnswer();
    }
    update();
  }

  bool isSnackBarShown = false;

  // handle Wrong Answer Function //
  void handleWrongAnswer() {
    if (totalLives > 0) {
      totalLives.value--;
      update();
      if (totalLives == 0) {
        timer?.cancel();
        showGameOverDialog();
      } else {
        generateNewQuestion();
        resetTimer();
      }
    }
  }

  // showGame Over Dialog Function//
  void showGameOverDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('Game Over')),
        content: Text('Your Score: ${totalPoints.value}'),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: const BorderSide(color: Colors.purple, width: 1)),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Exit'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                  onPressed: () {
                    Navigator.of(Get.context!).pop();
                    restartGame();
                  },
                  child: const Text(
                    'Restart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // restart Game Function//
  void restartGame() {
    totalPoints.value = 0;
    totalLives.value = 3;
    update();
    generateNewQuestion();
    resetTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  RxString displayValue = ''.obs;

  // Function to handle key press
  void onKeyPressed(String value) {
    displayValue.value += value;
    update();
  }

  // text clear function //
  void clear() {
    displayValue.value = '';
    update();
  }

  // back space Function //
  void backspace() {
    if (displayValue.value.isNotEmpty) {
      displayValue.value = displayValue.value.substring(0, displayValue.value.length - 1);
    }
    update();
  }

  // on Clear Function //
  void onClear() {
    displayValue.value = "";
    update();
  }

  // on Submit button //
  void onSubmit() {
    print("saddadsd");
    if (int.tryParse(displayValue.value) == answerCorrect.value) {
      _handleCorrectAnswer();
    } else {
      handleWrongAnswer1();
    }
  }

// Handle correct answer submission //
  void _handleCorrectAnswer() {
    print("Submitted Answer: $displayValue");
    totalPoints.value++;

    generateNewQuestion();
    resetTimer();
    displayValue.value = "";
    update();
  }

// Handle wrong answer submission //
  void handleWrongAnswer1() {
    if (totalLives.value > 0) {
      totalLives.value--;

      update();
      if (totalLives.value == 0) {
        _handleGameOver();
      } else {
        _prepareForNextAttempt();
      }
    }
  }


// Handle game over logic  //
  void _handleGameOver() {
    timer?.cancel();
    showGameOverDialog();
  }

// Prepare for the next question and reset the timer //
  void _prepareForNextAttempt() {
    isSnackBarShown = false;
    generateNewQuestion();
    resetTimer();
  }
}
