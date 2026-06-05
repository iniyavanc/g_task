import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_task/features/products/data/repository/product_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  @override
  Widget build(BuildContext context) {
    final product = ref.watch(getProductsViewProvider);
    return Scaffold(
      appBar: AppBar(actions: []),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                autoPlay: false,
                viewportFraction: 1,
              ),
              items: (product!.images ?? []).map((image) {
                return Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(product.description ?? ''),

                  const SizedBox(height: 16),

                  Text("Price : ₹${product.price}"),

                  const SizedBox(height: 8),

                  Text("Stock : ${product.stock}"),

                  const SizedBox(height: 8),

                  Text("Rating : ${product.rating}"),

                  const SizedBox(height: 8),

                  Text("Brand : ${product.brand}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
