import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../data/social_repository.dart';
import '../domain/user_profile.dart';
import '../../auth/data/auth_repository.dart';
import '../../../../core/theme/app_colors.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfile? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  File? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile?.displayName ?? '');
    _bioController = TextEditingController(text: widget.initialProfile?.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _imageFile != null 
                      ? FileImage(_imageFile!) 
                      : (widget.initialProfile?.photoUrl != null 
                          ? NetworkImage(widget.initialProfile!.photoUrl!) 
                          : null) as ImageProvider?,
                    child: (_imageFile == null && widget.initialProfile?.photoUrl == null)
                      ? const Icon(Icons.add_a_photo, size: 30, color: AppColors.secondaryAccent)
                      : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.secondaryAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'DISPLAY NAME',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'BIO',
                prefixIcon: Icon(Icons.info_outline),
                alignLabelWithHint: true,
              ),
            ),
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      String? photoUrl = widget.initialProfile?.photoUrl;
      if (_imageFile != null) {
        photoUrl = await ref.read(socialRepositoryProvider).uploadProfilePicture(user.uid, _imageFile!);
      }

      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        photoUrl: photoUrl,
        followersCount: widget.initialProfile?.followersCount ?? 0,
        followingCount: widget.initialProfile?.followingCount ?? 0,
        createdAt: widget.initialProfile?.createdAt,
      );

      await ref.read(socialRepositoryProvider).updateProfile(profile);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
