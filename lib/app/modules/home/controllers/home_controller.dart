import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  int totalPoints = 0;
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

  // reset Timer Function //
  void resetTimer() {
    timer?.cancel();
    timeLeft = 10;
    startTimer();
    update();
  }

  // generate New Question Function //
  void generateNewQuestion() {
    Random random = Random();
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    List<String> operators = ['+', '-', '*'];
    String operator = operators[random.nextInt(3)];

    switch (operator) {
      case '+':
        answerCorrect = num1 + num2;
        break;
      case '-':
        answerCorrect = num1 - num2;
        break;
      case '*':
        answerCorrect = num1 * num2;
        break;
    }

    question = '$num1 $operator $num2';
    rightAnswer = '';
    update();
  }

  // check Answer Right Or Wrong //
  void checkAnswerRightOrWrong() {
    if (int.tryParse(rightAnswer) == answerCorrect) {
      totalPoints++;
      correctAmount.clear();
      update();
      generateNewQuestion();
      resetTimer();
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
      builder: (_) => AlertDialog(
        title: const Center(child: Text('Game Over')),
        content: Text('Your Score: $totalPoints'),
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
    totalPoints = 0;
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
}
