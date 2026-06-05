import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_task/core/constants/api_constants.dart';
import 'package:g_task/features/products/data/model/product_response.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

class CreateProduct extends ConsumerStatefulWidget {
  final Products? product;
  final int? hiveIndex;
  const CreateProduct({super.key, this.product, this.hiveIndex});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      nameController.text = widget.product!.title ?? '';
      descriptionController.text = widget.product!.description ?? '';
      priceController.text = widget.product!.price?.toString() ?? '';
      categoryController.text = widget.product!.category ?? '';
    }
  }

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse(ApiConstants.addProduct),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": nameController.text,
        "price": double.parse(priceController.text),
        "description": descriptionController.text,
        "category": categoryController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      final box = Hive.box('products');

      if (widget.hiveIndex != null) {
        await box.putAt(widget.hiveIndex!, responseData);
      } else {
        await box.add(responseData);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Add Product" : "Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }

                  if (double.tryParse(value) == null) {
                    return "Enter valid price";
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submit,
                child:  Text(widget.product == null ? "Submit" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
