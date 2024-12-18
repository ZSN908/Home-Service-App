import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:home_service/services/cloudinary_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:home_service/utils/alert_utils.dart';
import 'package:home_service/utils/auth_utils.dart';
import 'package:home_service/widgets/custom_text_field.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String uId;
  final String initialemail;
  final String initialName;
  final String initialAbout;
  final String initialImageUrl;
  const ProfileScreen({
    super.key,
    required this.uId,
    required this.initialemail,
    required this.initialName,
    required this.initialAbout,
    required this.initialImageUrl,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutController = TextEditingController();

  File? _profileImage;

  bool _isAboutFieldFocused = false;
  bool _newImageVisible = false;
  bool isLoading = false;

  // Check if the current data is different from the initial values
  bool _hasChanges() {
    final updatedName = _nameController.text.trim();
    final updatedEmail = _emailController.text.trim();
    final updatedAbout = _aboutController.text.trim();

    // Check if there's any difference in name, email, about, or image
    return updatedName != widget.initialName ||
        updatedEmail != widget.initialemail ||
        updatedAbout != widget.initialAbout ||
        (_profileImage != null);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              backgroundColor: Colors.white,
              statusBarColor: Colors.white,
              toolbarColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true,
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _newImageVisible = true;
            _profileImage = File(croppedFile.path);
          });
        }
      }
    } catch (error) {
      _showMessage("Error picking image: $error");
    }
  }

  void _resetImage() {
    setState(() {
      _profileImage = null;
      _newImageVisible = false;
    });
  }

  Future<String> _uploadImage(File imageFile) async {
    final imageUrl =
        await CloudinaryService.uploadImage(imageFile, "profile_pictures");

    if (imageUrl == null) {
      throw Exception("Image upload failed");
    }

    return imageUrl;
  }

  Future<bool> _deleteOldImage() async {
    final success = await CloudinaryService.deleteImage(widget.initialImageUrl);
    if (!success) {
      log("Failed to delete old image");
    }
    return success;
  }

  void _handleUpdate() async {
    if (!_hasChanges()) {
      _showMessage("Please make a change to update your profile.");
      return;
    }

    final updatedName = _nameController.text.trim();
    final updatedEmail = _emailController.text.trim();
    final updatedAbout = _aboutController.text.trim();
    if (updatedName.isEmpty) {
      _showMessage("Name field is empty!");
      return;
    } else if (updatedEmail.isEmpty) {
      _showMessage("Email field is empty!");
    } else if (updatedAbout.isEmpty) {
      _showMessage("About field is empty!");
    } else if (!AuthUtils.isValidEmail(_emailController.text)) {
      _showMessage("Invalid email address!");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      String? imageUrl =
          _profileImage != null ? await _uploadImage(_profileImage!) : null;

      String resultMessage = await ref
          .read(userProvider.notifier)
          .updateProfile(
              userId: widget.uId,
              name: updatedName,
              email: updatedEmail,
              about: updatedAbout,
              profilePictureUrl: imageUrl);
      if (resultMessage == 'Profile updated successfully') {
        // Fetch and update user data after successful otp validation
        await ref.read(userProvider.notifier).fetchUserData();

        // Delete the old image if a new one is uploaded
        if (_profileImage != null && imageUrl != null) {
          await _deleteOldImage();
        }
        _goBack();
        //  https://c0.wallpaperflare.com/preview/73/996/927/man-side-profile-profile-face-thumbnail.jpg
      }
      _showMessage(resultMessage);
    } catch (e) {
      _showMessage("Update failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _showMessage(String message) {
    AlertUtils.showMessage(context, message);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _emailController.text = widget.initialemail;
    _aboutController.text = widget.initialAbout;
    log('uersId is: ${widget.uId}');
    log('imageUrl: ${widget.initialImageUrl}');

    // Add a focus listener to the About field
    _aboutController.addListener(() {
      setState(() {
        _isAboutFieldFocused = true;
      });
    });
  }

  // Method to remove focus from About field
  void _removeFocusFromAbout(bool change) {
    setState(() {
      if (!change) {
        _aboutController.text = widget.initialAbout;
      }
      _isAboutFieldFocused = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_isAboutFieldFocused)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _newImageVisible && _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              height: 93,
                              width: 93,
                              fit: BoxFit.cover,
                            )
                          : (widget.initialImageUrl == '')
                              ? Image.asset(
                                  height: 93,
                                  width: 93,
                                  'hs_assets/images/defaultProfile.png',
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(
                                  height: 93,
                                  width: 93,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.initialImageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 28.3,
                        width: 28.3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                    Positioned(
                      bottom: 2.5,
                      right: 2.5,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 67, 120, 255),
                              // border: Border.all(width: 3, color: Colors.white),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (_newImageVisible)
                      Positioned(
                        top: 0,
                        left: 2,
                        child: GestureDetector(
                          onTap: _resetImage,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.59),
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 15,
                              color: Color.fromARGB(245, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Column(
              children: [
                if (!_isAboutFieldFocused) ...[
                  customTitleRow(
                    name: 'Full Name',
                    padd: false,
                    context: context,
                  ),
                  buildTextField(
                      authForm: false,
                      controller: _nameController,
                      hintText: 'Name'),
                  customTitleRow(
                    name: 'Email',
                    padd: false,
                    context: context,
                  ),
                  buildTextField(
                    authForm: false,
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                ],
                customTitleRow(
                  name: 'About',
                  padd: false,
                  context: context,
                ),
                buildTextField(
                  authForm: false,
                  controller: _aboutController,
                  hintText: 'About',
                  multiLines: true,
                ),
                if (_isAboutFieldFocused)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // CustomIconButton(
                      //   icon: Icons.close,
                      //   color: Colors.grey.shade800,
                      //   onPressed: () {
                      //     _removeFocusFromAbout(false);
                      //   },
                      // ),
                      // const SizedBox(width: 15),
                      CustomIconButton(
                        iconBtn: true,
                        icon: Icons.check,
                        color: Colors.black,
                        onPressed: () {
                          _removeFocusFromAbout(true);
                        },
                      ),
                    ],
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.black)),
                    )
                  : CustomButton(
                      title: 'Save',
                      onPressed: _handleUpdate,
                      vertpadd: 12,
                      textStyle: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 16.2),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
