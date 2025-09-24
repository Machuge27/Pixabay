import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pixabay_image.dart';
import '../services/pixabay_service.dart';

final pixabayServiceProvider = Provider<PixabayService>((ref) => PixabayService());

final trendingImagesProvider = FutureProvider<List<PixabayImage>>((ref) async {
  final service = ref.read(pixabayServiceProvider);
  return service.getTrendingImages();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchOrderProvider = StateProvider<String>((ref) => 'popular');
final searchCategoryProvider = StateProvider<String>((ref) => 'all');

final searchImagesProvider = FutureProvider<List<PixabayImage>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final order = ref.watch(searchOrderProvider);
  final category = ref.watch(searchCategoryProvider);
  
  final service = ref.read(pixabayServiceProvider);
  return service.searchImages(query, order: order, category: category);
});