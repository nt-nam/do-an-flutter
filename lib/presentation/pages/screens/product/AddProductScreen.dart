import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_event.dart';
import '../../../blocs/product/product_state.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile; // Lưu file ảnh được chọn
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Chọn ảnh từ camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Lưu ảnh vào bộ nhớ cục bộ và trả về đường dẫn
  Future<String> _saveImageLocally(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localPath = '${directory.path}/$imageName';
    await image.copy(localPath);
    return localPath;
  }

  // Tải ảnh lên API và nhận imageUrl
  Future<String?> _uploadImageToApi(File image) async {
    const apiUrl = 'YOUR_API_ENDPOINT/sanpham/upload'; // Thay bằng URL API của bạn
    final token = 'YOUR_AUTH_TOKEN'; // Lấy token từ AuthService nếu cần

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      // Giả sử API trả về JSON với trường "imageUrl"
      return responseData.body; // Điều chỉnh theo định dạng phản hồi của API
    } else {
      throw Exception('Failed to upload image');
    }
  }

  void _submitProduct(BuildContext context) async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final categoryId = int.tryParse(_categoryIdController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();

    if (name.isEmpty || price <= 0 || stock < 0 || categoryId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ và đúng thông tin!')),
      );
      return;
    }

    String? imageUrl;
    if (_imageFile != null) {
      try {
        // Lưu ảnh cục bộ
        final localPath = await _saveImageLocally(_imageFile!);
        // Tải ảnh lên API và lấy imageUrl
        imageUrl = await _uploadImageToApi(_imageFile!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải ảnh: $e')),
        );
        return;
      }
    }

    context.read<ProductBloc>().add(
      AddProductEvent(
        name: name,
        categoryId: categoryId,
        price: price,
        stock: stock,
        imageUrl: imageUrl,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm sản phẩm thành công!')),
              );
              Navigator.pop(context);
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: ${state.message}')),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng tồn kho',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _categoryIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ID danh mục',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả (tuỳ chọn)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImageFromCamera,
                      child: const Text('Chụp ảnh'),
                    ),
                    ElevatedButton(
                      onPressed: _pickImageFromGallery,
                      child: const Text('Chọn từ thư viện'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 24),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () => _submitProduct(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Thêm sản phẩm',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}