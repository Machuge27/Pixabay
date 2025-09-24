import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pixabay_provider.dart';
import '../components/image_card.dart';
import '../components/image_viewer.dart';

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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search millions of images...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          ),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: _performSearch,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Search'),
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  onSubmitted: (_) => _performSearch(),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(searchQueryProvider.notifier).state = '';
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: ref.watch(searchOrderProvider),
                        decoration: InputDecoration(
                          labelText: 'Sort by',
                          prefixIcon: const Icon(Icons.sort),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
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
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Categories'),
                          ),
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
              data: (images) {
                if (images.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          query.isEmpty
                              ? 'Start searching for images'
                              : 'No images found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (query.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Try different keywords or filters',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  );
                }
                final isMobile = MediaQuery.of(context).size.width < 700;
                return isMobile ? _buildListView(images) : _buildGridView(images);
              },
              loading:
                  () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Searching images...'),
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
                          'Search failed',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('$error', textAlign: TextAlign.center),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(searchImagesProvider),
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

  Widget _buildGridView(List images) {
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
      itemBuilder: (context, index) => ImageCard(image: images[index]),
    );
  }

  Widget _buildListView(List images) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () => showDialog(
              context: context,
              builder: (context) => ImageViewer(image: image),
            ),
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
