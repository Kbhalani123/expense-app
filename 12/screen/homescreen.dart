import 'package:app_me/12/database/db_helper.dart';
import 'package:app_me/12/shareprefence/pref_management.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  List<Map<String, dynamic>> _expenses = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  void loadUserId() async {
    _userId = await _sharedPreferencesHelper.getUserId();
    fetchExpenses();
  }

  void fetchExpenses() async {
    if (_userId != null) {
      final expenses = await _databaseHelper.getExpenses(_userId!);
      setState(() {
        _expenses = expenses;
      });
    }
  }

  void showAddExpenseDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Expense Name')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_userId != null) {
                  _databaseHelper.addExpense(
                      nameController.text,
                      descriptionController.text,
                      double.parse(amountController.text),
                      _userId!);
                  fetchExpenses();
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteExpense(int id) {
    _databaseHelper.deleteExpense(id);
    fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expenses")),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return ListTile(
            title: Text(expense['name']),
            subtitle: Text('${expense['description']} - \$${expense['amount']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteExpense(expense['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
