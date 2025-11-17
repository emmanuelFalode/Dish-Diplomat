import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:foodapp/core/auth_storage.dart';
import 'package:foodapp/providers/dish_api.dart';

part 'me_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> me(MeRef ref) async {
  final token = await AuthStorage.readToken();
  if (token == null || token.isEmpty) throw 'No session token';
  final res = await ApiService.me(token);
  if (res['success'] == true) return Map<String, dynamic>.from(res['data']);
  throw res['message'] ?? 'Failed to load profile';
}


