import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:g_task/core/constants/api_constants.dart';
import 'package:g_task/features/products/data/model/product_response.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<ProductRespponse> getProduct() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getProducts),
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint("response :${response.body}");
      if (response != null) {
        final data = jsonDecode(response.body);
        debugPrint("DATA :${data}");
        return ProductRespponse.fromJson(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductRespponse> searchProduct(String query) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.searchProducts(query)),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      debugPrint("DATA :${data}");
      return ProductRespponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}

final productProvider = FutureProvider<ProductRespponse>((ref) async {
  return await ProductRepository().getProduct();
});

final getProductsViewProvider = StateProvider<Products?>((ref) => null);

final searchProductProvider = FutureProvider.family<ProductRespponse, String>((
  ref,
  query,
) async {
  return ProductRepository().searchProduct(query);
});
