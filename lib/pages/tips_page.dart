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

  Future<List<dynamic>> fetchMyTips(dynamic userId) async {
    try {
      Response response = await Client.dio.get('/tips');
      List<dynamic> allTips = response.data;

      List<dynamic> myTips = allTips.where((tip) {
        return tip['authorId'] == userId;
      }).toList();

      return myTips;
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

  Future<void> voteTip(String tipId, bool isUpvote) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await Client.dio.put(
        isUpvote ? '/tips/$tipId/upvote' : '/tips/$tipId/downvote',
        options: Options(
          headers: {'Authorization': 'Bearer ${authProvider.token}'},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote recorded successfully')),
      );
      setState(() {}); // Refresh the state to show updated votes
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to record vote')),
      );
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
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.yellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: TabBarView(
                children: [
                  _buildAllTipsTab(authProvider),
                  _buildMyTipsTab(authProvider),
                ],
              ),
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
                // Sort tips by votes (upvotes - downvotes)
                tips.sort((a, b) {
                  int scoreA =
                      a['upvotes']?.length ?? 0 - a['downvotes']?.length ?? 0;
                  int scoreB =
                      b['upvotes']?.length ?? 0 - b['downvotes']?.length ?? 0;
                  return scoreB.compareTo(scoreA); // Sort descending
                });

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
      future: fetchMyTips(authProvider.user?.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading tips: ${snapshot.error}'));
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
    int upvotes = tip['upvotes']?.length ?? 0;
    int downvotes = tip['downvotes']?.length ?? 0;

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
              tip['text'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By ${tip['author'] ?? 'Unknown'}',
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
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: Colors.blueAccent),
                      onPressed: () => voteTip(tip['id'], true), // Upvote
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$upvotes',
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.thumb_down, color: Colors.redAccent),
                      onPressed: () => voteTip(tip['id'], false), // Downvote
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$downvotes',
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
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
