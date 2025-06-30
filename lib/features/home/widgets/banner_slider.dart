import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({Key? key}) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _banners = [
    'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
    'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
    'https://www.usatoday.com/gcdn/presto/2020/03/17/USAT/c0eff9ec-e0e4-42db-b308-f748933229ee-XXX_ThinkstockPhotos-200460053-001.jpg?crop=1170,658,x292,y120&width=1170&height=658&format=pjpg&auto=webp',
    'https://images.pexels.com/photos/1805164/pexels-photo-1805164.jpeg',
    'https://images.pexels.com/photos/1170986/pexels-photo-1170986.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % _banners.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _banners[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return Container(
                margin: const EdgeInsets.all(4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
