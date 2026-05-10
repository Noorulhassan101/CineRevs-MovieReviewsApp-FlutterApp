import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/media_item.dart';
import '../../core/theme/app_colors.dart';
import 'glass_container.dart';

class MediaCard extends StatefulWidget {
  final MediaItem item;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: 200.ms,
          curve: Curves.easeOutCubic,
          child: Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                // Poster Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 2/3,
                    child: widget.item.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl: widget.item.posterPath!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: AppColors.surface),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )
                        : Container(color: AppColors.surface),
                  ),
                ),
                
                // Glow Border on Hover
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.secondaryAccent.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryAccent.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Glassmorphism Overlay for Rating
                Positioned(
                  top: 8,
                  right: 8,
                  child: GlassContainer(
                    borderRadius: 8,
                    blur: 5,
                    opacity: 0.2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            widget.item.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Metadata Gradient
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),

                // Title
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    widget.item.title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
