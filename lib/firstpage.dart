import 'package:flutter/material.dart';
import '../services/image_api_service.dart';
import '../models/image_model.dart';

class ImageListPage extends StatelessWidget {
  const ImageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text('Image Gallery'),
        centerTitle: true,
        elevation: 2,
      ),

      body: FutureBuilder<List<ImageModel>>(
        future: ImageApiService.fetchImages(),
        builder: (context, snapshot) {
          // 1️⃣ Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2️⃣ Error State
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // 3️⃣ Data State
          final images = snapshot.data ?? [];

          if (images.isEmpty) {
            return const Center(child: Text('No images found'));
          }

          // 4️⃣ Grid UI
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  images[index].imageUrl,
                  fit: BoxFit.cover,

                  // Image loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },

                  // Image error
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
