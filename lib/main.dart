// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SwipeImagesScreen(),
    );
  }
}

class SwipeImagesScreen extends StatefulWidget {
  const SwipeImagesScreen({super.key});

  @override
  _SwipeImagesScreenState createState() => _SwipeImagesScreenState();
}

class _SwipeImagesScreenState extends State<SwipeImagesScreen> {
  List<String> allImages = [
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    // Добавьте здесь пути к вашим изображениям
  ];

  List<String> favorites = [];
  List<String> blacklist = [];

  List<String> currentImages = [];

  int currentIndex = 0;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    if (allImages.isEmpty) {
      setState(() {
        currentImages.add("На сегодня всё");
      });
      return;
    }

    List<String> availableImages = List.from(allImages);

    // Удаляем изображения, которые уже просмотрены
    availableImages.removeWhere(
        (image) => favorites.contains(image) || blacklist.contains(image));

    if (availableImages.isEmpty) {
      setState(() {
        currentImages.add("На сегодня всё");
      });
      return;
    }

    int randomIndex = Random().nextInt(availableImages.length);
    setState(() {
      currentIndex = allImages.indexOf(availableImages[randomIndex]);
      currentImages.add(allImages[currentIndex]);
    });
  }

  void _swipeLeft() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _swipeRight() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _addToFavorites() {
    setState(() {
      String currentImage = allImages[currentIndex];
      if (!favorites.contains(currentImage)) {
        favorites.add(currentImage);
      }
    });
    _loadImages();
  }

  void _addToBlacklist() {
    setState(() {
      String currentImage = allImages[currentIndex];
      if (!blacklist.contains(currentImage)) {
        blacklist.add(currentImage);
      }
    });
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipe Images"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentImages.isNotEmpty &&
                currentImages[0] != "На сегодня всё")
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: currentImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(currentImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = allImages.indexOf(currentImages[index]);
                    });
                  },
                ),
              )
            else
              const Text(
                "На сегодня всё",
                style: TextStyle(fontSize: 20),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: _addToFavorites,
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: _addToBlacklist,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
