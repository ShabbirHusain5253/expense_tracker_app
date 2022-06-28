import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
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
                            '\$${userTransaction![index].amount}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransaction![index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(DateFormat.yMMMd()
                        .format(userTransaction![index].date)),
                    trailing: MediaQuery.of(context).size.width > 420
                        ? TextButton.icon(
                            onPressed: () {
                              deleteTransactionHandler!(
                                  userTransaction![index].id);
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
                              deleteTransactionHandler!(
                                  userTransaction![index].id);
                            },
                          ),
                  ),
                );
              },
              itemCount: userTransaction!.length,
            ),
          );
  }
}
