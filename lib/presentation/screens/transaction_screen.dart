import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  final String memberId;

  const TransactionScreen({super.key, required this.memberId});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Builder(
        builder: (scaffoldContext) {
          return Center(
            child: Text("Transaction Screen"),
          );
        },
      ),
    );
  }
}
