import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pixabay_provider.dart';
import '../components/image_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingImages = ref.watch(trendingImagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Images'),
        automaticallyImplyLeading: false,
        leading: MediaQuery.of(context).size.width < 700
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: trendingImages.when(
              data:
                  (images) => GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 1200
                              ? 4
                              : MediaQuery.of(context).size.width > 800
                              ? 3
                              : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: images.length,
                    itemBuilder:
                        (context, index) => ImageCard(image: images[index]),
                  ),
              loading:
                  () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading trending images...'),
                      ],
                    ),
                  ),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load images',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('$error', textAlign: TextAlign.center),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(trendingImagesProvider),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
