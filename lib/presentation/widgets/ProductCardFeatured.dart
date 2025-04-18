import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../pages/screens/HomeScreen.dart'; // Thêm import cho Lottie

class FeaturedCard extends StatefulWidget {
  final String title;
  final String price;
  final String time;
  final String imageUrl;
  final VoidCallback? onTap;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.price,
    required this.time,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    // Animation cho scale khi nhấn
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Animation cho ngôi sao lấp lánh
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _sparkleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _sparkleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 200,
              height: 230,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // colors: [Colors.teal.shade100, Colors.teal.shade300],
                  colors: [Colors.black87, Colors.black26],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: ClipRRect(
                  //     borderRadius: const BorderRadius.vertical(
                  //       bottom: Radius.circular(20), // Bo hai góc dưới
                  //     ),
                  //     child: Lottie.asset(
                  //       'assets/animation/fire.json',
                  //       width: double.infinity,
                  //       height: 200, // Điều chỉnh kích thước tùy ý
                  //       fit: BoxFit.contain,
                  //       repeat: true,
                  //     ),
                  //   ),
                  // ),
                  // Ảnh sản phẩm
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20)),
                      child: Container(
                        width: double.infinity,
                        height: 230,
                        // Chiều cao cố định cho ảnh
                        color: Colors.white.withOpacity(0.1),
                        // Nền nhẹ cho ảnh trong suốt
                        child: Image.asset(
                          // widget.imageUrl
                          "assets/images/${(widget.imageUrl ?? HomeScreen.linkImage) == "" ? HomeScreen.linkImage : (widget.imageUrl ?? HomeScreen.linkImage)}",
                          fit: BoxFit.cover, // Giữ nguyên tỷ lệ ảnh
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/default.jpg",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.propane_tank_outlined,
                                    size: 40,
                                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                                  ),
                                );
                              },
                            );
                          },
                          // loadingBuilder: (context, child, loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return const Center(
                          //       child: CircularProgressIndicator());
                          // },
                        ),
                      ),
                    ),
                  ),
                  // Nội dung text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                      shadows: _shadow(),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _sparkleAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _sparkleAnimation.value,
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.price,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.timer,
                                    size: 14, color: Colors.black87),
                                const SizedBox(width: 4),
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Shadow> _shadow() {
    return [
      Shadow(
        color: Colors.white,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
      Shadow(
        color: Colors.white,
        offset: Offset(-1, 1),
        blurRadius: 2,
      ),
      Shadow(
        color: Colors.white,
        offset: Offset(1, -1),
        blurRadius: 2,
      ),
      Shadow(
        color: Colors.white,
        offset: Offset(-1, -1),
        blurRadius: 2,
      ),
    ];
  }
}
