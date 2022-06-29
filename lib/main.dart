import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
              fontFamily: 'Opensans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Opensans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(null),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(Key? key) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 34.49,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 12.18,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'New Shoes',
      amount: 34.49,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Weekly Groceries',
      amount: 12.18,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'New Shoes',
      amount: 34.49,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Weekly Groceries',
      amount: 12.18,
      date: DateTime.now(),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransactions
        .where((tx) => tx.date.isAfter(DateTime.now().subtract(const Duration(
              days: 7,
            ))))
        .toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addNewTransactionHandler: _addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    // print(id);
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Expense Tracker App'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  child: Icon(CupertinoIcons.add),
                  onPressed: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Expense Tracker App'),
            actions: [
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(Icons.add))
            ],
          ) as PreferredSizeWidget);
    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.68,
      child: TransactionList(
        userTransaction: _userTransactions,
        deleteTransactionHandler: _deleteTransaction,
      ),
    );
    List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appBar,
      Widget txListWidget,
    ) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Show Chart'),
            Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart,
                onChanged: (value) {
                  setState(() {
                    _showChart = value;
                  });
                })
          ],
        ),
        if (_showChart)
          SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(recentTransaction: _recentTransaction))
        else
          txListWidget,
      ];
    }

    List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appBar,
      Widget txListWidget,
    ) {
      return [
        SizedBox(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.32,
            child: Chart(recentTransaction: _recentTransaction)),
        txListWidget,
      ];
    }

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? SizedBox(
                    height: 0,
                  )
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
