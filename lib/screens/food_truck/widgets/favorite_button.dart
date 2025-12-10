import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';

class FavoriteButton extends StatefulWidget {
  final int foodTruckId;
  final double size;

  const FavoriteButton({
    super.key,
    required this.foodTruckId,
    this.size = 24.0,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    setState(() => _isLoading = true);
    try {
      final isFavorite = await AppApi.favoriteApi.checkFavorite(
        widget.foodTruckId,
      );
      setState(() => _isFavorite = isFavorite);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check favorite status')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);
    final isFavorite = await AppApi.favoriteApi.checkFavorite(
      widget.foodTruckId,
    );
    try {
      if (isFavorite) {
        await AppApi.favoriteApi.removeFavorite(widget.foodTruckId);
      }
      if (!isFavorite) {
        await AppApi.favoriteApi.addFavorite(widget.foodTruckId);
      }
      setState(() => _isFavorite = !_isFavorite);
      setState(() => _isLoading = false);
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update favorite')));
    } finally {
      // setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          _isLoading
              ? SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey,
                size: widget.size,
              ),
      onPressed: _isLoading ? null : _toggleFavorite,
    );
  }
}
