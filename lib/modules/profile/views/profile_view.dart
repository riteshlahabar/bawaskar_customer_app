import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/profile_fields.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_detail_section.dart';
import 'widgets/profile_header_card.dart';
import '../../../app/localization/t.dart';

/// Account page: the customer's profile details and photo (menus live in the chips).
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user;
      final customer = ProfileFields.map(user['customer_profile']);
      final address = ProfileFields.defaultAddress(user['addresses']);
      final name = ProfileFields.text(user['name']).isNotEmpty ? ProfileFields.text(user['name']) : controller.name;
      final mobile = ProfileFields.text(user['mobile']).isNotEmpty ? ProfileFields.text(user['mobile']) : controller.mobile;
      final email = ProfileFields.realEmail(ProfileFields.text(user['email']).isNotEmpty ? ProfileFields.text(user['email']) : controller.email);
      final birthDate = DateTime.tryParse(ProfileFields.text(customer['date_of_birth']));
      final language = ProfileFields.text(customer['preferred_language']);

      return RefreshIndicator(
        onRefresh: controller.loadProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            ProfileHeaderCard(
              photoUrl: controller.photoUrl,
              title: name,
              subtitle: mobile.isNotEmpty ? mobile : email,
              uploading: controller.isUploading.value,
              onPick: controller.changePhoto,
            ),
            if (controller.isLoading.value && user.isEmpty)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            const SizedBox(height: 14),
            ProfileDetailSection(title: t('account.profile_details'), details: [
              (icon: Icons.person_outline_rounded, label: t('address.name'), value: name),
              (icon: Icons.phone_outlined, label: t('auth.mobile'), value: mobile),
              (icon: Icons.email_outlined, label: t('common.email'), value: email),
              (icon: Icons.cake_outlined, label: t('profile.dob'), value: birthDate == null ? '' : DateFormat('dd MMM yyyy').format(birthDate)),
              (icon: Icons.language_rounded, label: t('profile.preferred_language'), value: ProfileFields.languages[language] ?? language),
            ]),
            const SizedBox(height: 14),
            ProfileDetailSection(title: t('address.delivery_address'), details: [
              (
                icon: Icons.location_on_outlined,
                label: address.isEmpty ? 'Address' : ProfileFields.text(address['name']),
                value: ProfileFields.addressLine(address),
              ),
            ]),
          ],
        ),
      );
    });
  }
}
