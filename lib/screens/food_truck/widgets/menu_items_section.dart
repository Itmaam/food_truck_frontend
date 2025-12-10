import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/menu_item.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';

class MenuItemsSection extends StatefulWidget {
  final List<MenuItem> menuItems;
  final Function(int) onRemoveItem;
  final VoidCallback onAddItem;
  final Function(int, File) onImageSelected;

  const MenuItemsSection({
    super.key,
    required this.menuItems,
    required this.onRemoveItem,
    required this.onAddItem,
    required this.onImageSelected,
  });

  @override
  State<MenuItemsSection> createState() => _MenuItemsSectionState();
}

class _MenuItemsSectionState extends State<MenuItemsSection> {
  final ImagePicker _picker = ImagePicker();
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _descControllers = [];

  initController() {
    // Initialize controllers for existing items
    for (var item in widget.menuItems) {
      _nameControllers.add(TextEditingController(text: item.name));
      _descControllers.add(TextEditingController(text: item.description));
    }
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _descControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        widget.menuItems[index].imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.menuItemsTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...List.generate(widget.menuItems.length, (index) {
          final item = widget.menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameControllers[index],
                              decoration: InputDecoration(labelText: lang.menuItemsTitle, border: OutlineInputBorder()),
                              onChanged: (value) => item.name = value,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descControllers[index],
                              decoration: InputDecoration(
                                labelText: lang.itemDescription,
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                              onChanged: (value) => item.description = value,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          widget.onRemoveItem(index);
                          initController();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(onPressed: () => _pickImage(index), child: Text(lang.addImageButton)),
                      const SizedBox(width: 8),
                      // if (item.imageUrl != null || item.imageFile != null)
                      //   Text(
                      //     item.imageFile?.path.split('/').last ?? item.imageUrl?.split('/').last ?? '',
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                    ],
                  ),
                  if (item.imageUrl != null || item.imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:
                          item.imageFile != null
                              ? Image.file(item.imageFile!, height: 100, fit: BoxFit.cover)
                              : Image.network(item.imageUrl!, height: 100, fit: BoxFit.cover),
                    ),
                ],
              ),
            ),
          );
        }),
        ElevatedButton(
          onPressed: () {
            widget.onAddItem.call();
            initController();
          },
          child: Text(lang.addMenuItemButton),
        ),
      ],
    );
  }
}
