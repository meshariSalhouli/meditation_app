import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditation_app/services/clinet.dart'; // Ensure this is the correct path

class CreateTipPage extends StatefulWidget {
  @override
  _CreateTipPageState createState() => _CreateTipPageState();
}

class _CreateTipPageState extends State<CreateTipPage> {
  final TextEditingController _tipController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _submitTip() async {
    if (!_formKey.currentState!.validate()) {
      return; // Validation failed
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await Client.dio.post(
        '/tips',
        data: {'text': _tipController.text},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tip created successfully!')),
        );
        _tipController.clear();
      }
    } on DioError catch (e) {
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create tip: ${e.message}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Tip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tipController,
                decoration: InputDecoration(
                  labelText: 'Tip Text',
                  border: OutlineInputBorder(),
                ),
                maxLength: 200, // Maximum length of the tip
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tip';
                  } else if (value.length > 200) {
                    return 'Tip must be 200 characters or less';
                  }
                  return null; // Validation passed
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitTip,
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Tip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
