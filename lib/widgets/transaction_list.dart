import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction>? userTransaction;
  final void Function(String)? deleteTransactionHandler;

  const TransactionList(
      {Key? key, this.userTransaction, this.deleteTransactionHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userTransaction!.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : Container(
            child: ListView.builder(
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return TransactionItem(
                    transaction: userTransaction![index],
                    deleteTransactionHandler: deleteTransactionHandler);
              },
              itemCount: userTransaction!.length,
            ),
          );
  }
}
