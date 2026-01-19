import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/types/transaction_type.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../cubit/add_transaction_cubit.dart';
import '../cubit/add_transaction_state.dart';

@RoutePage()
class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  // Fake categories for MVP
  final List<Map<String, String>> _categories = [
    {'id': 'cat_food', 'name': 'Food'},
    {'id': 'cat_transport', 'name': 'Transport'},
    {'id': 'cat_salary', 'name': 'Salary'},
    {'id': 'cat_freelance', 'name': 'Freelance'},
    {'id': 'cat_shopping', 'name': 'Shopping'},
    {'id': 'cat_bills', 'name': 'Bills'},
  ];

  @override
  void initState() {
    super.initState();
    // Set default category
    if (_categories.isNotEmpty) {
      _selectedCategoryId = _categories.first['id'];
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      context.read<AddTransactionCubit>().submitTransaction(
            amount: double.parse(_amountController.text),
            type: _selectedType,
            categoryId: _selectedCategoryId!,
            date: _selectedDate,
            note: _noteController.text.isEmpty ? null : _noteController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddTransactionCubit>(),
      child: BlocListener<AddTransactionCubit, AddTransactionState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: () {
              // Pop the screen with success result
              // TransactionsPage will receive this result and refresh
              context.router.pop(true);
              
              // Show success message after navigation
              Future.delayed(const Duration(milliseconds: 300), () {
                final navigatorContext = context.router.navigatorKey.currentContext;
                if (navigatorContext != null) {
                  ScaffoldMessenger.of(navigatorContext).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              });
            },
            failure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${failure.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('New Transaction'),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Transaction Type
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<TransactionType>(
                          segments: const [
                            ButtonSegment(
                              value: TransactionType.expense,
                              label: Text('Expense'),
                              icon: Icon(Icons.arrow_upward),
                            ),
                            ButtonSegment(
                              value: TransactionType.income,
                              label: Text('Income'),
                              icon: Icon(Icons.arrow_downward),
                            ),
                          ],
                          selected: {_selectedType},
                          onSelectionChanged: (Set<TransactionType> newSelection) {
                            setState(() {
                              _selectedType = newSelection.first;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'],
                      child: Text(category['name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Note
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Submit Button
                BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  builder: (context, state) {
                    final isLoading = state is AddTransactionStateLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create Transaction'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
