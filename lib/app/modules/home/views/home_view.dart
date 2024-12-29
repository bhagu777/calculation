import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        assignId: true,
        init: HomeController(),
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 100,
                    color: Colors.purple,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                  3,
                                  (index) => Icon(
                                    index < controller.totalLives
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                'Points: ${controller.totalPoints.value}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    height: controller.getContainerHeight(),
                    color: controller.getColorBasedOnTime(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.question,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      controller: TextEditingController(
                          text: controller.displayValue.value),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Answer',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        controller.rightAnswer = value;
                      },
                      onSubmitted: (value) {
                        controller.rightAnswer = value;
                        controller.checkAnswerRightOrWrong();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter ,
                    child: Container(
                      color: Colors.purple.withOpacity(0.5),
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisExtent: 70,
                          mainAxisSpacing: 20,
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          if (index == 9) {
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => controller.onClear(),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: Colors.redAccent,
                                ),
                                child: const Text(
                                  "CE",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            );
                          } else if (index == 10) {
                            // "0" button
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => controller.onKeyPressed("0"),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: Colors.purple,
                                ),
                                child: const Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            );
                          } else if (index == 11) {
                            // Submit button
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.onSubmit();
                                  controller.update();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Icon(Icons.check,
                                    size: 24, color: Colors.white),
                              ),
                            );
                          } else {
                            // Numbers 1-9
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => controller
                                    .onKeyPressed((index + 1).toString()),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: Colors.purple.withOpacity(0.5),
                                ),
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
