import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/user_auth_manager.dart';
import 'package:food_truck_finder_user_app/api/models/review.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';

class ReviewTabView extends StatefulWidget {
  final bool myTruck;
  final int foodTruckId;

  const ReviewTabView({super.key, required this.foodTruckId, required this.myTruck});

  @override
  State<ReviewTabView> createState() => _ReviewTabViewState();
}

class _ReviewTabViewState extends State<ReviewTabView> {
  late Future<List<Review>> _reviewsFuture;
  bool _isLoading = false;
  final Map<int, bool> _expandedReviews = {};

  Future<bool> _userHasReviewed() async {
    if (UserAuthManager.isLoggedIn) {
      final response = await AppApi.reviewApi.getReviews(widget.foodTruckId);
      final userId = UserAuthManager.currentUser?.id;
      return response.any((review) => review.user?.id == userId);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews();
  }

  Future<List<Review>> _fetchReviews() async {
    try {
      final response = await AppApi.reviewApi.getReviews(widget.foodTruckId);
      return response;
    } catch (e) {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> _refreshReviews() async {
    setState(() {
      _reviewsFuture = _fetchReviews();
      _expandedReviews.clear();
    });
  }

  void _showAddReviewDialog({String initialComment = '', double initialRating = 5, int? reviewId}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String comment = initialComment;
    double dialogRating = initialRating;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(S.of(context).writeReview),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(S.of(context).rating, style: context.theme.textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.small),
                    RatingStars(
                      value: dialogRating,
                      onValueChanged: (value) {
                        setDialogState(() => dialogRating = value);
                      },
                      starColor: context.theme.primaryColor,
                      starSize: 30,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    TextFormField(
                      decoration: InputDecoration(labelText: S.of(context).required),
                      initialValue: initialComment,
                      validator: (value) => value!.isEmpty ? S.of(context).required : null,
                      onChanged: (value) => comment = value,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        await AppApi.reviewApi.createReview(
                          widget.foodTruckId,
                          dialogRating.toInt(),
                          comment,
                          reviewId,
                        );
                        await _refreshReviews();
                      } finally {
                        setState(() => _isLoading = false);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    }
                  },
                  child:
                      _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(S.of(context).submit),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReviewItem(Review review, int index) {
    final isExpanded = _expandedReviews[index] ?? false;
    final maxLines = isExpanded ? null : 3;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.user?.image != null ? NetworkImage(review.user!.image) : null,
                  child: review.user?.image == null ? Icon(Icons.person, size: 20) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.user?.name ?? 'Anonymous', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              i < review.rating ? Icons.star : Icons.star_border,
                              color: i < review.rating ? context.theme.primaryColor : Colors.grey,
                              size: 16,
                            ),
                          const SizedBox(width: 8),
                          Text(review.formattedDate, style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final textPainter = TextPainter(
                  text: TextSpan(text: review.comment, style: Theme.of(context).textTheme.bodyMedium),
                  maxLines: 3,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                final needsReadMore = textPainter.didExceedMaxLines;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.comment,
                      maxLines: maxLines,
                      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
                    ),
                    if (needsReadMore)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _expandedReviews[index] = !isExpanded;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isExpanded ? 'Read Less' : 'Read More',
                          style: TextStyle(color: context.theme.primaryColor),
                        ),
                      ),
                  ],
                );
              },
            ),
            // user can delete and edit their own review
            if (review.user?.id == UserAuthManager.currentUser?.id)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showAddReviewDialog(
                        initialComment: review.comment,
                        initialRating: review.rating.toDouble(),
                        reviewId: review.id,
                      );
                    },
                    child: Text(S.of(context).edit),
                  ),
                  // TextButton(
                  //   onPressed: () async {
                  //     final confirm = await showDialog<bool>(
                  //       context: context,
                  //       builder:
                  //           (context) => AlertDialog(
                  //             title: Text(S.of(context).confirm),
                  //             content: Text(S.of(context).areYouSureYouWantToDeleteThisReview),
                  //             actions: [
                  //               TextButton(
                  //                 onPressed: () => Navigator.pop(context, false),
                  //                 child: Text(S.of(context).cancel),
                  //               ),
                  //               ElevatedButton(
                  //                 onPressed: () => Navigator.pop(context, true),
                  //                 child: Text(S.of(context).confirmDelete),
                  //               ),
                  //             ],
                  //           ),
                  //     );
                  //     if (confirm == true) {
                  //       setState(() => _isLoading = true);
                  //       try {
                  //         //await AppApi.reviewApi.deleteReview(review.id);
                  //         await _refreshReviews();
                  //       } finally {
                  //         setState(() => _isLoading = false);
                  //       }
                  //     }
                  //   },
                  //   child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  // ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(S.of(context).review, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (!widget.myTruck && UserAuthManager.isLoggedIn)
                  FutureBuilder(
                    future: _userHasReviewed(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (asyncSnapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      final hasReviewed = asyncSnapshot.data ?? false;
                      if (hasReviewed) {
                        return const SizedBox.shrink();
                      }
                      return TextButton.icon(
                        onPressed: _showAddReviewDialog,
                        icon: const Icon(Icons.rate_review),
                        label: Text(S.of(context).addReview),
                      );
                    },
                  ),
                if (widget.myTruck) Text(S.of(context).yourFoodTruck, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshReviews,
              child: FutureBuilder<List<Review>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }

                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text(S.of(context).noReviews, style: Theme.of(context).textTheme.bodyMedium));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final review = snapshot.data![index];
                      return _buildReviewItem(review, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
