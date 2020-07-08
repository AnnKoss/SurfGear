import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surfpay/controller/payment_controller.dart';
import 'package:surfpay/data/apple_payment_request.dart';
import 'package:surfpay/data/google_pay_data.dart';
import 'package:surfpay/data/goole_payment_request.dart';
import 'package:surfpay/data/payment_item.dart';
import 'package:surfpay/ui/apple_button.dart';
import 'package:surfpay/ui/google_button.dart';

import 'data/apple_pay_data.dart';

class Surfpay extends StatefulWidget {
  const Surfpay({
    Key key,
    this.customButton,
    this.buttonForceShow = false,
    this.googlePayData,
    this.applePayData,
    this.onSuccess,
    this.onCancel,
    this.onError,
  }) : super(key: key);

  final Widget Function(BuildContext context) customButton;
  final SuccessCallback onSuccess;
  final VoidCallback onCancel;
  final ErrorCallback onError;

  final GooglePayData googlePayData;
  final ApplePayData applePayData;

  final bool buttonForceShow;

  @override
  State<StatefulWidget> createState() {
    return _SurfpayState();
  }
}

class _SurfpayState extends State<Surfpay> {
  PaymentController _paymentController;

  @override
  void initState() {
    super.initState();
    _paymentController = PaymentController(
      applePayData: widget.applePayData,
      googlePayData: widget.googlePayData,
      onSuccess: widget.onSuccess,
      onCancel: widget.onCancel,
      onError: widget.onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _paymentController.isServiceAvailable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const SizedBox();
        if (snapshot.data as bool) {
          if (Platform.isAndroid) {
            return _buildAndroid();
          }
          return _buildApple();
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildAndroid() {
    if (widget.customButton == null) {
      return GoogleButton(
        onTap: () => _paymentController.pay(
          exampleGoogleRequest,
          exampleAppleRequest,
        ),
      );
    }
    return widget.customButton(context);
  }

  Widget _buildApple() {
    if (widget.customButton == null) {
      return AppleButton(
        onTap: () => _paymentController.pay(
          exampleGoogleRequest,
          exampleAppleRequest,
        ),
      ); //_paymentController.pay());
    }
    return widget.customButton(context);
  }
}

final exampleGoogleRequest = GooglePaymentRequest(
  "60000.00",
  {
    'merchantName': 'Example Merchant',
  },
  false,
  ["RU"],
  false,
);

final exampleAppleRequest = ApplePaymentRequest(
  [
    PaymentItem("IPhone", "60000.00", true),
  ],
  "RUB",
  "RU",
);