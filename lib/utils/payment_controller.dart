// ignore_for_file: avoid_dynamic_calls

import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/config.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/features/core/logic/app_config_provider.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/utils/stripe_payment_data/stripe_payment_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PaymentController {
  Dio getStripeDio() {
    final Dio dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppConfig.secretKey}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    return dio;
  }

  Map<String, dynamic>? paymentIntentData;
  Future<bool> makePayment(
      {required String amount,
      required String currency,
      required String packageID,
      required WidgetRef ref}) async {
    bool hasMadePayment = false;
    String paymentID = '';

    try {
      paymentIntentData =
          await createPaymentIntent(amount, currency, packageID);
      if (paymentIntentData != null) {
        paymentID = paymentIntentData!['id'] as String;

        final String? customer = paymentIntentData!['customer'] as String?;
        final String ephimeralKey = await getEphimeralKey(customer: customer!);
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            customerId: customer,
            merchantDisplayName: 'Prospects',
            paymentIntentClientSecret:
                paymentIntentData!['client_secret'] as String?,
            customerEphemeralKeySecret: ephimeralKey,
            allowsDelayedPaymentMethods: true,
          ),
        );
        try {
          EasyLoading.showInfo("Making Payment");
          await Stripe.instance.presentPaymentSheet();

          EasyLoading.dismiss();
          // EasyLoading.showInfo("Placing Order");

          await paymentSuccess(
              packageID: packageID, paymentID: paymentID, ref: ref);
          hasMadePayment = true;
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Subscribed Successfully");
        } on Exception catch (e) {
          if (e is StripeException) {
            debugPrint("Error from Stripe: ${e.error.localizedMessage}");
          } else {
            debugPrint("Unforeseen error: $e");
          }
        } catch (e) {
          debugPrint("exception:$e");
        }
      }
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
    return hasMadePayment;
  }

  //Creates Payment Intent
  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
    String packageID,
  ) async {
    final Dio dio = getStripeDio();
    final Box userBox = Hive.box(AppHSC.userBox);
    final dynamic userID = userBox.get("id");
    final String? userName = userBox.get("name") as String?;

    final String? customer = await getCustomer();
    String plaform = "Android";
    if (Platform.isIOS) {
      plaform = "iOS";
    }

    final Map<String, dynamic> body = {
      'customer': customer,
      'amount': calculateAmount(amount),
      'currency': currency,
      'description':
          "$userName's (User ID : $userID) Payment for OrderID $packageID from $plaform",
      "payment_method_types[]": "card",
      "setup_future_usage": "off_session"
    };
    final response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      data: body,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<String?> getCustomer() async {
    String? customer;
    final Box userBox = Hive.box(AppHSC.userBox);
    customer = userBox.get(AppHSC.stripeCustomerID) as String?;
    final Dio stripeDio = getStripeDio();
    final String? name = userBox.get('name') as String?;

    if (customer == null) {
      final Response response = await stripeDio.post(
        "https://api.stripe.com/v1/customers",
        data: {
          'name': name,
        },
      );
      if (response.statusCode == 200) {
        customer = response.data["id"] as String?;
        userBox.put(AppHSC.stripeCustomerID, customer);
      }
    }
    return customer;
  }

  Future<void> attachpaymentMethod({
    required String customer,
    required String paymentMethod,
  }) async {
    final Dio stripeDio = getStripeDio();

    await stripeDio.post(
      "https://api.stripe.com/v1/payment_methods/$paymentMethod/attach",
      data: {
        'customer': customer,
      },
    );
  }

  Future<void> updateCustomerDefaultMethod({
    required String customer,
    required String paymentMethod,
  }) async {
    final Dio stripeDio = getStripeDio();

    await stripeDio.post(
      "https://api.stripe.com/v1/customers/$customer",
      data: {
        'invoice_settings[default_payment_method]': paymentMethod,
      },
    );
  }

  Future<String> getEphimeralKey({
    required String customer,
  }) async {
    final Dio stripeDio = getStripeDio();

    final Response response = await stripeDio.post(
      "https://api.stripe.com/v1/ephemeral_keys",
      data: {
        'customer': customer,
      },
      options: Options(headers: {'Stripe-Version': "2022-08-01"}),
    );
    return response.data['secret'] as String;
  }

  String calculateAmount(String amount) {
    debugPrint(amount);
    final a = (double.parse(amount)) * 100;
    return a.toInt().toString();
  }

  Future<void> paymentSuccess(
      {required String paymentID,
      required String packageID,
      required WidgetRef ref}) async {
    //Assign Dio
    final authDio = ref.watch(dioProvider);
    final stripeDio = getStripeDio();

    final response = await stripeDio.get(
      'https://api.stripe.com/v1/payment_intents/$paymentID',
    );
    final StripePaymentData paymentData =
        StripePaymentData.fromMap(response.data as Map<String, dynamic>);

    final String? customer = await getCustomer();
    await attachpaymentMethod(
      customer: customer ?? '',
      paymentMethod: paymentData.charges!.data!.first.paymentMethod!,
    );

    await updateCustomerDefaultMethod(
      customer: customer ?? '',
      paymentMethod: paymentData.charges!.data!.first.paymentMethod!,
    );
    authDio
        .post(
      '/get/subscription',
      data: FormData.fromMap({
        'plan_id': int.parse(packageID).toString(),
      }),
    )
        .then((value) {
      // ignore: unused_result
      ref.refresh(userProvider);
    });
    // ignore: unused_result

    EasyLoading.showSuccess('Payment Success');
  }
}
