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
              body: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: controller.getContainerHeight(), // Full-screen height
                    width: MediaQuery.of(Get.context!).size.width, // Full-screen width
                    color: controller.getColorBasedOnTime(),
                  ),
                  SingleChildScrollView(
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
                                          index < controller.totalLives.value ? Icons.favorite : Icons.favorite_border,
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
                        SizedBox(height: Get.height / 3),
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
                            controller: TextEditingController(text: controller.displayValue.value),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Answer',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              controller.rightAnswer.value = value;
                            },
                            onSubmitted: (value) {
                              controller.rightAnswer.value = value;
                              controller.checkAnswerRightOrWrong();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.grey.withOpacity(0.4),
                            padding: const EdgeInsets.all(8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 70,
                                mainAxisSpacing: 10,
                              ),
                              padding: EdgeInsets.zero,
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                if (index == 9) {
                                  return ElevatedButton(
                                    onPressed: () => controller.onClear(),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      shadowColor: Colors.black12,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Custom border radius
                                      ),
                                    ),
                                    child: const Text(
                                      "CE",
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  );
                                } else if (index == 10) {
                                  return ElevatedButton(
                                    onPressed: () => controller.onKeyPressed("0"),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.black12,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Custom border radius
                                      ),
                                    ),
                                    child: const Text(
                                      "0",
                                      style: TextStyle(fontSize: 24, color: Colors.black),
                                    ),
                                  );
                                } else if (index == 11) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      controller.onSubmit();
                                      controller.update();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.black12,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Custom border radius
                                      ),
                                    ),
                                    child: const Icon(Icons.check, size: 24, color: Colors.black),
                                  );
                                } else {
                                  return ElevatedButton(
                                    onPressed: () => controller.onKeyPressed((index + 1).toString()),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.black12,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Custom border radius
                                      ),
                                    ),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(fontSize: 24, color: Colors.black),
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
                ],
              )
              /* Column(
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
                                  index < controller.totalLives.value
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
                      controller.rightAnswer.value = value;
                    },
                    onSubmitted: (value) {
                      controller.rightAnswer.value = value;
                      controller.checkAnswerRightOrWrong();
                    },
                  ),
                ),

                SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
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
                                backgroundColor:
                                    Colors.purple.withOpacity(0.5),
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
            )*/
              );
        });
  }
}
