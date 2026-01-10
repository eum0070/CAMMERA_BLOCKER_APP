import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show.dart';

class ShowService {
  static const String baseUrl =
      'http://172.31.77.182:3000/api/shows'; // Node.js API

  static Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Show.fromJson(json)).toList();
    } else {
      throw Exception('공연 정보를 불러오지 못했습니다');
    }
  }
}
