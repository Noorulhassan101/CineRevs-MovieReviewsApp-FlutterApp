import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/adaptive_colors.dart';
import '../../auth/data/auth_repository.dart';
import '../data/reviews_repository.dart';
import '../data/community_repository.dart';
import '../data/questionnaire_repository.dart';
import '../domain/community_model.dart';
import 'widgets/review_card.dart';
import 'widgets/questionnaire_sheet.dart';
import 'widgets/chat_section.dart';

part 'community_details_screen.g.dart';

@riverpod
Stream<Community> watchCommunity(WatchCommunityRef ref, String communityId) {
  return ref.watch(communityRepositoryProvider).watchCommunity(communityId);
}

class CommunityDetailsScreen extends ConsumerStatefulWidget {
  final Community community;
  const CommunityDetailsScreen({super.key, required this.community});

  @override
  ConsumerState<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends ConsumerState<CommunityDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    // Watch community changes to get real-time membership updates
    final communityAsync = ref.watch(watchCommunityProvider(widget.community.id));
    final isMember = communityAsync.maybeWhen(
      data: (updatedCommunity) => user != null && updatedCommunity.memberIds.contains(user.uid),
      orElse: () => user != null && widget.community.memberIds.contains(user.uid),
    );
    final reviewsAsync = ref.watch(communityReviewsProvider(widget.community.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.community.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryAccent.withOpacity(0.3),
                      AppColors.background,
                    ],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.groups, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
            actions: [
              if (user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _JoinLeaveButton(communityId: widget.community.id, isMember: isMember),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MISSION_DESCRIPTION',
                    style: TextStyle(color: AppColors.secondaryAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.community.description,
                    style: TextStyle(color: context.adaptiveWhite70, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _StatItem(label: 'MEMBERS', value: widget.community.membersCount.toString()),
                      const SizedBox(width: 48),
                      _StatItem(label: 'CATEGORY', value: widget.community.category.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Tab Bar for Reviews and Chat
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(child: Text('REVIEWS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
                      Tab(child: Text('CHAT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    ],
                    labelColor: AppColors.primaryAccent,
                    unselectedLabelColor: context.adaptiveWhite54,
                    indicatorColor: AppColors.primaryAccent,
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Reviews Tab
                _ReviewsTab(reviewsAsync: reviewsAsync, community: widget.community),
                
                // Chat Tab
                ChatSection(
                  communityId: widget.community.id,
                  isMember: isMember,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final AsyncValue reviewsAsync;
  final Community community;

  const _ReviewsTab({required this.reviewsAsync, required this.community});

  @override
  Widget build(BuildContext context) {
    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Text(
              'NO REVIEWS IN THIS COMMUNITY YET.',
              style: TextStyle(color: context.adaptiveWhite24, fontSize: 10),
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ReviewCard(review: reviews[index]),
                  childCount: reviews.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _JoinLeaveButton extends ConsumerStatefulWidget {
  final String communityId;
  final bool isMember;
  const _JoinLeaveButton({required this.communityId, required this.isMember});

  @override
  ConsumerState<_JoinLeaveButton> createState() => _JoinLeaveButtonState();
}

class _JoinLeaveButtonState extends ConsumerState<_JoinLeaveButton> {
  bool _isLoading = false;

  Future<void> _handleJoinWithQuestionnaire() async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;

    setState(() => _isLoading = true);
    try {
      // Check if community has a questionnaire
      final questionnaire = await ref.read(questionnaireRepositoryProvider).getCommunityQuestionnaire(widget.communityId);

      if (questionnaire != null && questionnaire.questions.isNotEmpty) {
        // Show questionnaire modal
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => QuestionnaireSheet(
              questionnaire: questionnaire,
              communityId: widget.communityId,
              onCompleted: () {
                // After questionnaire is submitted, join the community
                ref.read(communityRepositoryProvider).joinCommunity(widget.communityId, userId);
              },
            ),
          );
        }
      } else {
        // No questionnaire, join directly
        await ref.read(communityRepositoryProvider).joinCommunity(widget.communityId, userId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () async {
        if (widget.isMember) {
          final userId = ref.read(authRepositoryProvider).currentUser?.uid;
          if (userId == null) return;
          
          setState(() => _isLoading = true);
          try {
            await ref.read(communityRepositoryProvider).leaveCommunity(widget.communityId, userId);
          } finally {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
        } else {
          await _handleJoinWithQuestionnaire();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isMember ? Colors.white10 : AppColors.primaryAccent,
        foregroundColor: widget.isMember ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 36),
      ),
      child: _isLoading 
        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(widget.isMember ? 'LEAVE' : 'JOIN', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
