class ApiConstants {
  static const getProducts = "https://dummyjson.com/products";

  static String searchProducts(String query) =>
      'https://dummyjson.com/products/search?q=$query';

  static const addProduct = "https://dummyjson.com/products/add";
}
