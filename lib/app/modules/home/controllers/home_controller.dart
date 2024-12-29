import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt totalPoints = 0.obs;
  int totalLives = 3;
  String question = '';
  int answerCorrect = 0;
  String rightAnswer = '';
  Timer? timer;
  int timeLeft = 10;
  TextEditingController correctAmount = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    generateNewQuestion();
    startTimer();
  }

  // start Timer Function //
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        update();
      } else {
        handleWrongAnswer();
      }
    });
  }

  // get Container Height Function//
  double getContainerHeight() {
    return 150 + (10 - timeLeft) * 12;
  }

  // get Color Based On Time Function //
  Color getColorBasedOnTime() {

    double red = 255;
    double green = 255 - ((255 - 105) * (10 - timeLeft) / 10);
    double blue = 255 - ((255 - 180) * (10 - timeLeft) / 10);

    return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1.0);
  }

  // reset Timer Function //
  void resetTimer() {
    timer?.cancel();
    timeLeft = 10;
    startTimer();
    displayValue.value = '';
    update();
  }

  // generate New Question Function //
  void generateNewQuestion() {
    Random random = Random();
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    List<String> operators = ['+', '-', 'X'];
    String operator = operators[random.nextInt(3)];

    switch (operator) {
      case '+':
        answerCorrect = num2 + num1;
        break;
      case '-':
        answerCorrect = num2 - num1;
        break;
      case '*':
        answerCorrect = num2 * num1;
        break;
    }

    question = '$num1 $operator $num2';
    rightAnswer = '';
    update();
  }

  // check Answer Right Or Wrong Function //
  void checkAnswerRightOrWrong() {
    if (int.tryParse(rightAnswer) == answerCorrect) {
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
      totalLives--;
      correctAmount.clear();

      if (!isSnackBarShown) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Answer is incorrect'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        isSnackBarShown = true;
      }

      update();

      if (totalLives == 0) {
        timer?.cancel();
        showGameOverDialog();
      } else {
        isSnackBarShown = false;
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: Colors.purple, width: 1)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
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
    totalLives = 3;
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
    displayValue.value +=
        value;
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
      displayValue.value =
          displayValue.value.substring(0, displayValue.value.length - 1);
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
    if (int.tryParse(displayValue.value) == answerCorrect) {
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
    update();

    displayValue.value = "";
    update();
  }

// Handle wrong answer submission //
  void handleWrongAnswer1() {
    if (totalLives > 0) {
      totalLives--;
      correctAmount.clear();
      _showWrongAnswerSnackBar();
      update();
      if (totalLives == 0) {
        _handleGameOver();
      } else {
        _prepareForNextAttempt();
      }
    }
  }

// Show snackbar for wrong answer feedback //
  void _showWrongAnswerSnackBar() {
    if (!isSnackBarShown) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Answer is incorrect'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      isSnackBarShown =
          true;
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
