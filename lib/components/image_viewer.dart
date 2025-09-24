import 'package:flutter/material.dart';
import '../models/pixabay_image.dart';

class ImageViewer extends StatelessWidget {
  final PixabayImage image;

  const ImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(image.tags, style: const TextStyle(fontSize: 16)),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    image.webformatURL,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.white, size: 64),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(image.user[0].toUpperCase()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'By ${image.user}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          image.tags,
                          style: const TextStyle(color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      Text(' ${image.likes}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      const Icon(Icons.visibility, color: Colors.white70, size: 20),
                      Text(' ${image.views}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      const Icon(Icons.download, color: Colors.white70, size: 20),
                      Text(' ${image.downloads}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}