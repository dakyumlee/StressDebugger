import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _analyze() async {
    if (_textController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.createLog(_textController.text);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
        _textController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StressDebugger', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '오늘 하루 어땠어?',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'TaebaekEunhasu',
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '오늘 있었던 일을 자유롭게 써봐...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: const Color(0xFFB0BFAE),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFB0BFAE))
                    : const Text('분석하기', style: TextStyle(fontFamily: 'TaebaekEunhasu', fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
