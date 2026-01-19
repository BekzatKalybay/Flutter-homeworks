import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/types/transaction_type.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';

@RoutePage()
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionsBloc>()
        ..add(const TransactionsFetchStarted()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearch = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_currentSearch != value) {
      _currentSearch = value;
      context.read<TransactionsBloc>().add(TransactionsSearchChanged(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (items, query, isOffline, isRefreshing) {
              return Column(
                children: [
                  if (isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange,
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Offline mode - showing cached data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<TransactionsBloc>().add(
                              const TransactionsRefreshRequested(),
                            );
                        // Wait a bit for the refresh to complete
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      child: isRefreshing
                          ? const Center(child: CircularProgressIndicator())
                          : items.isEmpty
                              ? const Center(
                                  child: Text('No transactions found'),
                                )
                              : ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final transaction = items[index];
                                    return _TransactionItem(
                                      transaction: transaction,
                                      onTap: () {
                                        context.router.push(
                                          TransactionDetailsRoute(
                                            id: transaction.id,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              );
            },
            empty: (query, isOffline) {
              return Column(
                children: [
                  if (isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange,
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Offline mode',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  const Expanded(
                    child: Center(
                      child: Text('No transactions found'),
                    ),
                  ),
                ],
              );
            },
            failure: (failure, query, isOffline) {
              return Column(
                children: [
                  if (isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange,
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Offline mode - showing cached data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${failure.message}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<TransactionsBloc>().add(
                                    const TransactionsRefreshRequested(),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(const TransactionCreateRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;

  const _TransactionItem({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final prefix = isIncome ? '+' : '-';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
      ),
      title: Text(transaction.note ?? 'No description'),
      subtitle: Text(
        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
      ),
      trailing: Text(
        '$prefix\$${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
