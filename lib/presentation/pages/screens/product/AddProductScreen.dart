import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageName;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        await _handlePickedImage(pickedFile);
      }
    } catch (e) {
      _showErrorSnackbar('Lỗi khi chụp ảnh: ${e.toString()}');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        await _handlePickedImage(pickedFile);
      }
    } catch (e) {
      _showErrorSnackbar('Lỗi khi chọn ảnh: ${e.toString()}');
    }
  }

  Future<void> _handlePickedImage(XFile pickedFile) async {
    if (kIsWeb) {
      _imageBytes = await pickedFile.readAsBytes();
      _imageName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } else {
      _imageFile = File(pickedFile.path);
      await _saveImageLocally(_imageFile!);
    }
    setState(() {});
  }

  Future<void> _saveImageLocally(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    _imageName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localPath = '${directory.path}/$_imageName';
    await image.copy(localPath);
    _imageFile = File(localPath);
  }

  Future<String?> _getImageBase64() async {
    try {
      if (kIsWeb && _imageBytes != null) {
        return 'data:image/jpeg;base64,${base64Encode(_imageBytes!)}';
      } else if (!kIsWeb && _imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('Lỗi xử lý ảnh: ${e.toString()}');
      return null;
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submitProduct(BuildContext context) async {
    if (_isUploading) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final categoryId = int.tryParse(_categoryIdController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    if (name.isEmpty || price <= 0 || stock < 0 || categoryId <= 0) {
      _showErrorSnackbar('Vui lòng nhập đầy đủ và đúng thông tin!');
      return;
    }

    setState(() => _isUploading = true);

    try {
      context.read<ProductBloc>().add(
        AddProductEvent(
          name: name,
          categoryId: categoryId,
          price: price,
          stock: stock,
          imageFile: _imageFile, // Truyền File thay vì base64
          description: description,
        ),
      );
    } catch (e) {
      _showErrorSnackbar('Lỗi khi thêm sản phẩm: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
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
                const SnackBar(
                  content: Text('Thêm sản phẩm thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is ProductError) {
              _showErrorSnackbar('Lỗi: ${state.message}');
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_nameController, 'Tên sản phẩm'),
                const SizedBox(height: 16),
                _buildNumberField(_priceController, 'Giá (VNĐ)'),
                const SizedBox(height: 16),
                _buildNumberField(_stockController, 'Số lượng tồn kho'),
                const SizedBox(height: 16),
                _buildNumberField(_categoryIdController, 'ID danh mục'),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildImageButtons(),
                const SizedBox(height: 16),
                _buildImagePreview(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Mô tả (tuỳ chọn)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageButtons() {
    return Row(
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
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && _imageFile != null) {
      return Image.file(
        _imageFile!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: const Center(
        child: Text('Chưa có ảnh được chọn'),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading || _isUploading) {
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
    );
  }
}
