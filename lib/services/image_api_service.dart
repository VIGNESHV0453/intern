import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageApiService {
  static const String apiUrl = "https://picsum.photos/v2/list";

  static Future<List<ImageModel>> fetchImages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load images");
    }
  }
}
