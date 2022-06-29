import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransactionHandler,
  }) : super(key: key);

  final Transaction? transaction;
  final void Function(String p1)? deleteTransactionHandler;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${transaction!.amount}',
              ),
            ),
          ),
        ),
        title: Text(
          transaction!.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction!.date)),
        trailing: MediaQuery.of(context).size.width > 420
            ? TextButton.icon(
                onPressed: () {
                  deleteTransactionHandler!(transaction!.id);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deleteTransactionHandler!(transaction!.id);
                },
              ),
      ),
    );
  }
}
