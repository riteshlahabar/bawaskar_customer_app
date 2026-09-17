import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/profile_fields.dart';
import '../../../app/widgets/app_card.dart';
import '../../location/views/location_form_fields.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../app/localization/t.dart';

/// Edit name, email, birth date and language. Mobile is the login identity, so
/// it is shown but cannot be changed; the photo is changed on the Account screen.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.edit_profile'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: controller.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: t('address.name'), prefixIcon: const Icon(Icons.person_outline_rounded)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: controller.mobile,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: t('auth.mobile'),
                    helperText: t('profile.mobile_locked'),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: t('account.email_optional'), prefixIcon: const Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final date = controller.birthDate.value;

                  return InkWell(
                    onTap: () => controller.pickBirthDate(context),
                    borderRadius: BorderRadius.circular(14),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: t('profile.dob_optional'), prefixIcon: const Icon(Icons.cake_outlined)),
                      child: Text(date == null ? t('profile.select_date') : DateFormat('dd MMM yyyy').format(date)),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Obx(
                  () => DropdownButtonFormField<String>(
                    key: ValueKey(controller.language.value),
                    initialValue: controller.language.value.isEmpty ? null : controller.language.value,
                    decoration: InputDecoration(labelText: t('profile.preferred_language'), prefixIcon: const Icon(Icons.language_rounded)),
                    items: [
                      for (final entry in ProfileFields.languages.entries)
                        DropdownMenuItem(value: entry.key, child: Text(entry.value)),
                    ],
                    onChanged: (value) => controller.language.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 12),
                LocationFormFields(controller: controller.location),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSaving.value ? null : controller.save,
                    child: Text(controller.isSaving.value ? t('common.saving') : t('profile.save_changes')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
