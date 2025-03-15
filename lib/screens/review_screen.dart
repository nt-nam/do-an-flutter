// lib/screens/review_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/review_bloc.dart';

class ReviewScreen extends StatefulWidget {
  final int productId;

  const ReviewScreen({required this.productId, Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewsEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đánh giá sản phẩm')),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đánh giá đã được gửi')));
            context.read<ReviewBloc>().add(LoadReviewsEvent(widget.productId)); // Tải lại danh sách
          }
          if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ReviewLoaded) {
            return Column(
              children: [
                Expanded(
                  child: state.reviews.isEmpty
                      ? Center(child: Text('Chưa có đánh giá nào'))
                      : ListView.builder(
                    itemCount: state.reviews.length,
                    itemBuilder: (context, index) {
                      final review = state.reviews[index];
                      return ListTile(
                        title: Text('${review.userName} - ${review.rating} sao'),
                        subtitle: Text(review.comment),
                        trailing: Text(review.createdAt.toString().substring(0, 10)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Đánh giá của bạn', style: TextStyle(fontSize: 18)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(labelText: 'Bình luận'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_rating > 0 && _commentController.text.isNotEmpty) {
                            context.read<ReviewBloc>().add(SubmitReviewEvent(
                              widget.productId,
                              _rating,
                              _commentController.text,
                            ));
                            _rating = 0;
                            _commentController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Vui lòng chọn sao và nhập bình luận')),
                            );
                          }
                        },
                        child: Text('Gửi đánh giá'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text('Chưa có dữ liệu đánh giá'));
        },
      ),
    );
  }
}