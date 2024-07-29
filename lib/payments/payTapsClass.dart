import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

class PayTapsClass {
  //todo: handel payment method PayTapsClass
  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");
    var shippingDetails = ShippingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "147514",
        serverKey: "SMJ9TLHG9N-JJLNNTR9GD-KTHD9BDL9H",
        clientKey: "CNK2KM-V27T66-BQQ7RP-TDNG9H",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: 20.0,
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "JOD",
        merchantCountryCode: "JO",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    final theme = IOSThemeConfigurations();
    configuration.iOSThemeConfigurations = theme;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed({double amount = 0 ,required void Function(dynamic) events}) async {
    PaymentSdkConfigurationDetails configuration = generateConfig();
    configuration.amount=amount;
    FlutterPaytabsBridge.startCardPayment(configuration,events);

  }

  Future<void> payWithTokenPressed() async {
    FlutterPaytabsBridge.startTokenizedCardPayment(
        generateConfig(), "*Token*", "*TransactionReference*", (event) {

        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });

  }

  Future<void> payWith3ds() async {
    FlutterPaytabsBridge.start3DSecureTokenizedCardPayment(
        generateConfig(),
        PaymentSDKSavedCardInfo("4111 11## #### 1111", "visa"),
        "*Token*", (event) {

        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
  }

  Future<void> payWithSavedCards() async {
    FlutterPaytabsBridge.startPaymentWithSavedCards(generateConfig(), false,
            (event) {

            if (event["status"] == "success") {
              // Handle transaction details here.
              var transactionDetails = event["data"];
              print(transactionDetails);
              if (transactionDetails["isSuccess"]) {
                print("successful transaction");
                if (transactionDetails["isPending"]) {
                  print("transaction pending");
                }
              } else {
                print("failed transaction");
              }

              // print(transactionDetails["isSuccess"]);
            } else if (event["status"] == "error") {
              // Handle error here.
            } else if (event["status"] == "event") {
              // Handle events here.
            }
          });

  }

  Future<void> apmsPayPressed() async {
    FlutterPaytabsBridge.startAlternativePaymentMethod(generateConfig(),
            (event) {

            if (event["status"] == "success") {
              // Handle transaction details here.
              var transactionDetails = event["data"];
              print(transactionDetails);
            } else if (event["status"] == "error") {
              // Handle error here.
            } else if (event["status"] == "event") {
              // Handle events here.
            }
          });

  }

  // Future<void> queryPressed() async {
  //   FlutterPaytabsBridge.queryTransaction(
  //       generateConfig(), generateQueryConfig(), (event) {
  //
  //       if (event["status"] == "success") {
  //         // Handle transaction details here.
  //         var transactionDetails = event["data"];
  //         print(transactionDetails);
  //       } else if (event["status"] == "error") {
  //         // Handle error here.
  //       } else if (event["status"] == "event") {
  //         // Handle events here.
  //       }
  //     });
  //
  // }

  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*Profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {

        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });

  }
}