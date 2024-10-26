import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditation_app/services/clinet.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/providers/auth_provider.dart';

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tipController = TextEditingController();
  bool isSubmitting = false;

  Future<List<dynamic>> fetchTips() async {
    try {
      Response response = await Client.dio.get('/tips');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchMyTips(String userId) async {
    try {
      Response response = await Client.dio.get('/tips');
      List<dynamic> allTips = response.data;
      return allTips.where((tip) => tip['authorId'] == userId).toList();
    } catch (e) {
      return [];
    }
  }

  int _wordCount(String text) {
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }

  Future<void> submitTip(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isSubmitting = true);

      await Client.dio.post(
        '/tips',
        data: {'text': _tipController.text},
        options: Options(
          headers: {'Authorization': 'Bearer ${authProvider.token}'},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tip created successfully')),
      );
      _tipController.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create tip')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Tips'),
              bottom: TabBar(
                tabs: [
                  Tab(text: "All Tips"),
                  Tab(text: "My Tips"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildAllTipsTab(authProvider),
                _buildMyTipsTab(authProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllTipsTab(AuthProvider authProvider) {
    return Column(
      children: [
        _buildTipForm(authProvider),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: fetchTips(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tips available.'));
              } else {
                final tips = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: tips.length,
                    itemBuilder: (context, index) {
                      final tip = tips[index];
                      return _buildTipCard(tip);
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyTipsTab(AuthProvider authProvider) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMyTips(authProvider.user?.id?.toString() ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tips created by you.'));
        } else {
          final tips = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return _buildTipCard(tip);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildTipForm(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _tipController,
              decoration: InputDecoration(
                labelText: 'Create a Tip (Max 100 words)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLength: 100,
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tip cannot be empty';
                }
                if (_wordCount(value) > 100) {
                  return 'Tip cannot exceed 100 words';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            isSubmitting
                ? CircularProgressIndicator()
                : Center(
                    child: ElevatedButton(
                      onPressed: () => submitTip(authProvider),
                      child: Text('Submit Tip'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(dynamic tip) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip['text'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By ${tip['author']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      '${tip['upvotes'].length}',
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.thumb_down, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Text(
                      '${tip['downvotes'].length}',
                      style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
