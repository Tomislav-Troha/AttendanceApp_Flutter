import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Define a generic CacheManager class
class CacheManager<T> {
  static const String _cacheKey = 'cacheKey';
  final Map<int, T> _cache = {};

  // Functions to convert T to and from JSON and to extract an ID
  final Function(dynamic) fromJson;
  final Function(T) toJson;
  final int Function(T) getIdFromItem;

  CacheManager({
    required this.fromJson,
    required this.toJson,
    required this.getIdFromItem,
  });

  Future<void> cacheItems(List<T> items) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonCache = prefs.getString(_cacheKey);

    if (jsonCache != null) {
      List<dynamic> jsonList = jsonDecode(jsonCache);

      for (var json in jsonList) {
        T item = fromJson(json);
        _cache.putIfAbsent(getIdFromItem(item), () => item);
      }
    }
    // Use getIdFromItem to extract ID
    for (var item in items) {
      _cache[getIdFromItem(item)] = item;
    }

    jsonCache = jsonEncode(_cache.values.map(toJson).toList());
    await prefs.setString(_cacheKey, jsonCache);
  }

  Future<List<T>> getCachedItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonCache = prefs.getString(_cacheKey);

    if (jsonCache != null) {
      List<dynamic> jsonList = jsonDecode(jsonCache);
      List<T> items = jsonList.map<T>((json) => fromJson(json)).toList();
      for (var item in items) {
        _cache[getIdFromItem(item)] = item;
      }
      return items;
    }

    return [];
  }

  T? getItemFromCache(int id) {
    return _cache[id];
  }

  void removeItemFromCache(int id) {
    _cache.remove(id);
  }

  Future<void> invalidateCache() async {
    // Clear in-memory cache
    _cache.clear();

    // Clear persisted cache data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
