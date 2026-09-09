import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Details', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 14),
                TextField(controller: controller.name, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 10),
                TextField(controller: controller.mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number')),
                const SizedBox(height: 10),
                TextField(controller: controller.address, maxLines: 2, decoration: const InputDecoration(labelText: 'Address')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: controller.city, decoration: const InputDecoration(labelText: 'City'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: controller.state, decoration: const InputDecoration(labelText: 'State'))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: controller.pincode, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Pincode')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 10),
                Obx(
                  () => RadioGroup<String>(
                    groupValue: controller.paymentMethod.value,
                    onChanged: (value) => controller.paymentMethod.value = value ?? 'COD',
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                          value: 'COD',
                          activeColor: AppColors.primary,
                          title: Text('Cash on Delivery / Pay on Delivery', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                        RadioListTile<String>(
  value: 'ONLINE',
  enabled: false,
  activeColor: AppColors.primary,
  title: Text(
    'Online Payment (Coming Soon)',
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
          TextField(controller: controller.notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Order Notes')),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.placeOrder,
                child: Text(controller.isLoading.value ? 'Placing Order...' : 'Place Order ₹${controller.cart.subtotal.toStringAsFixed(0)}'),
              )),
        ],
      ),
    );
  }
}
