
import 'dart:convert';

import 'package:expresspay_sdk/expresspay_sdk.dart';
import 'package:expresspay_sdk/src/adapters/BaseAdapter.dart';
import 'package:expresspay_sdk/src/Helpers.dart';

class ExpressPayGetTransactionDetailsAdapter extends BaseAdapter{

  // transactionId = selectedTransaction.id,
  // payerEmail = selectedTransaction.payerEmail,
  // cardNumber = selectedTransaction.cardNumber,
  // amount = amount,
  execute({
    required String transactionId,
    required String payerEmail,
    required String cardNumber,
    required TransactionDetailsResponseCallback? onResponse,
    required Function(dynamic)? onFailure,
    required Function(Map)? onResponseJSON,
  }){


    final params = {
      "transactionId" : transactionId,
      "payerEmail" : payerEmail,
      "cardNumber" : cardNumber,
    };

    startTransactionsDetail(params).listen((event) {
      Log(event);
      ExpresspayTransactionDetailResult(event).triggerCallbacks(onResponse, onResponseJSON: onResponseJSON);
    });

    Log("[ExpresspayTransactionDetailAdapter.execute][Params] ${jsonEncode(params)}");
  }
}