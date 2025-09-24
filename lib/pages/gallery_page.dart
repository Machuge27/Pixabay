import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pixabay_provider.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    ref.read(searchQueryProvider.notifier).state = query;
  }

  void _updateOrder(String? order) {
    if (order != null) {
      ref.read(searchOrderProvider.notifier).state = order;
    }
  }

  void _updateCategory(String? category) {
    if (category != null) {
      ref.read(searchCategoryProvider.notifier).state = category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchImages = ref.watch(searchImagesProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search images...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _performSearch(),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(searchQueryProvider.notifier).state = '';
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: ref.watch(searchOrderProvider),
                        decoration: const InputDecoration(
                          labelText: 'Order',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'popular', child: Text('Popular')),
                          DropdownMenuItem(value: 'latest', child: Text('Latest')),
                        ],
                        onChanged: _updateOrder,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: ref.watch(searchCategoryProvider),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(value: 'backgrounds', child: Text('Backgrounds')),
                          DropdownMenuItem(value: 'fashion', child: Text('Fashion')),
                          DropdownMenuItem(value: 'nature', child: Text('Nature')),
                          DropdownMenuItem(value: 'science', child: Text('Science')),
                          DropdownMenuItem(value: 'education', child: Text('Education')),
                          DropdownMenuItem(value: 'feelings', child: Text('Feelings')),
                          DropdownMenuItem(value: 'health', child: Text('Health')),
                          DropdownMenuItem(value: 'people', child: Text('People')),
                          DropdownMenuItem(value: 'religion', child: Text('Religion')),
                          DropdownMenuItem(value: 'places', child: Text('Places')),
                          DropdownMenuItem(value: 'animals', child: Text('Animals')),
                          DropdownMenuItem(value: 'industry', child: Text('Industry')),
                          DropdownMenuItem(value: 'computer', child: Text('Computer')),
                          DropdownMenuItem(value: 'food', child: Text('Food')),
                          DropdownMenuItem(value: 'sports', child: Text('Sports')),
                          DropdownMenuItem(value: 'transportation', child: Text('Transportation')),
                          DropdownMenuItem(value: 'travel', child: Text('Travel')),
                          DropdownMenuItem(value: 'buildings', child: Text('Buildings')),
                          DropdownMenuItem(value: 'business', child: Text('Business')),
                          DropdownMenuItem(value: 'music', child: Text('Music')),
                        ],
                        onChanged: _updateCategory,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: searchImages.when(
                    data: (images) => images.isEmpty
                        ? const Center(
                            child: Text(
                              'No images found',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : MediaQuery.of(context).size.width >= 700
                            ? _buildGridView(images)
                            : _buildListView(images),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: $error'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(searchImagesProvider),
                            child: const Text('Retry'),
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

  Widget _buildGridView(images) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 :
                       MediaQuery.of(context).size.width > 800 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      image.webformatURL,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By ${image.user}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          image.tags,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite, size: 14, color: Colors.red),
                            Text(' ${image.likes}', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(images) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image.previewURL,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            title: Text(
              image.tags,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('By ${image.user}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.red),
                    Text(' ${image.likes}'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, size: 16),
                    Text(' ${image.views}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
