import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:image_picker/image_picker.dart';

class PhotosSection extends StatefulWidget {
  final List<String> existingImageUrls;
  final List<File> photos;
  final Function(List<File>) onPhotosChanged;
  final Function(int) onDeleteExistingImage;
  final Function(int) onRemovePhoto;

  const PhotosSection({
    super.key,
    required this.existingImageUrls,
    required this.photos,
    required this.onPhotosChanged,
    required this.onDeleteExistingImage,
    required this.onRemovePhoto,
  });

  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection> {
  int _currentImageIndex = 0;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    // add option to pick from camera or gallery
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(S.of(context).selectImageSource),
            actions: [
              TextButton(
                onPressed: () async {
                  final photo = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  Navigator.pop(ctx, photo);
                },
                child: Text(S.of(context).camera),
              ),
              TextButton(
                onPressed: () async {
                  final photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  Navigator.pop(ctx, photo);
                },
                child: Text(S.of(context).gallery),
              ),
            ],
          ),
    );
    if (pickedFile != null) {
      final newPhotos = [...widget.photos, File(pickedFile.path)];
      widget.onPhotosChanged(newPhotos);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [...widget.existingImageUrls, ...widget.photos];
    final lang = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.photosTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.small),

        if (allImages.isNotEmpty) ...[
          Stack(
            children: [
              CarouselSlider.builder(
                itemCount: allImages.length,
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged:
                      (index, _) => setState(() => _currentImageIndex = index),
                ),
                itemBuilder: (context, index, _) {
                  if (index < widget.existingImageUrls.length) {
                    return Image.network(
                      '${allImages[index]}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Image.file(
                      widget.photos[index - widget.existingImageUrls.length],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1}/${allImages.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...widget.existingImageUrls.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text(lang.deleteImageDialogTitle),
                              content: Text(lang.deleteImageDialogContent),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(lang.cancelButton),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(lang.deleteButton),
                                ),
                              ],
                            ),
                      );
                      if (confirmed == true) {
                        widget.onDeleteExistingImage(entry.key);
                      }
                    },
                    child: _ImageThumbnail(
                      isSelected: _currentImageIndex == entry.key,
                      child: Image.network(
                        entry.value,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 50,
                      ),
                      onDelete: () => widget.onDeleteExistingImage(entry.key),
                    ),
                  );
                }),
                ...widget.photos.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => widget.onRemovePhoto(entry.key),
                    child: _ImageThumbnail(
                      isSelected:
                          _currentImageIndex ==
                          entry.key + widget.existingImageUrls.length,
                      child: Image.file(
                        entry.value,
                        fit: BoxFit.cover,
                        height: 40,
                      ),
                      onDelete: () => widget.onRemovePhoto(entry.key),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
        // Add Image Button image from gallery and camera
        SizedBox(height: AppSpacing.medium),
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(lang.addImageButton),
        ),
      ],
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final VoidCallback onDelete;

  const _ImageThumbnail({
    required this.isSelected,
    required this.child,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          child,
          InkWell(
            onTap: () => onDelete.call(),
            child: const Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.close, color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
