import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/training_model.dart';

class TrainingsCacheManager {
  static const String _cacheKey = 'trainingCache';
  final Map<int, TrainingResponseModel> _cache = {};

  Future<void> cacheTrainings(List<TrainingResponseModel> trainings) async {
    final prefs = await SharedPreferences.getInstance();
    for (var training in trainings) {
      _cache[training.ID_training!] = training;
    }
    String jsonCache = jsonEncode(trainings.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonCache);
  }

  Future<List<TrainingResponseModel>> getCachedTrainings() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonCache = prefs.getString(_cacheKey);

    if (jsonCache != null) {
      List<dynamic> jsonList = jsonDecode(jsonCache);
      List<TrainingResponseModel> trainings =
          jsonList.map((json) => TrainingResponseModel.fromJson(json)).toList();
      for (var training in trainings) {
        _cache[training.ID_training!] = training;
      }
      return trainings;
    }

    return [];
  }

  TrainingResponseModel? getTrainingFromCache(int id) {
    return _cache[id];
  }
}
