import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/checkout_controller.dart';
import 'widgets/checkout_address_card.dart';
import '../../../app/localization/t.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('checkout.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CheckoutAddressCard(service: controller.addresses),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('checkout.delivery_details'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 14),
                TextField(controller: controller.name, decoration: InputDecoration(labelText: t('address.full_name'))),
                const SizedBox(height: 10),
                TextField(controller: controller.mobile, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: t('address.mobile'))),
                const SizedBox(height: 10),
                TextField(controller: controller.address, maxLines: 2, decoration: InputDecoration(labelText: t('common.address'))),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: controller.city, decoration: InputDecoration(labelText: t('common.city')))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: controller.state, decoration: InputDecoration(labelText: t('address.state')))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: controller.pincode, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t('address.pincode'))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('checkout.payment_method'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 10),
                Obx(
                  () => RadioGroup<String>(
                    groupValue: controller.paymentMethod.value,
                    onChanged: (value) => controller.paymentMethod.value = value ?? 'COD',
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'COD',
                          activeColor: AppColors.primary,
                          title: Text(t('checkout.cod_long'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                        RadioListTile<String>(
  value: 'ONLINE',
  enabled: false,
  activeColor: AppColors.primary,
  title: Text(
    t('checkout.online_soon'),
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),
  ),
),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(controller: controller.notes, maxLines: 3, decoration: InputDecoration(labelText: t('checkout.notes'))),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.placeOrder,
                child: Text(controller.isLoading.value ? t('checkout.placing') : t('checkout.place_order', {'amount': '₹${controller.cart.subtotal.toStringAsFixed(0)}'})),
              )),
        ],
      ),
    );
  }
}
