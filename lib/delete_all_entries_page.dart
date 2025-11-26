import 'package:flutter/material.dart';

class DeleteAllEntriesPage extends StatelessWidget {
  const DeleteAllEntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete All Entries')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Confirm Delete All Entries'),
                content: const Text('Are you sure you want to delete all entries?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All entries deleted')),
                      );
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Delete All Entries'),
        ),
      ),
    );
  }
}
