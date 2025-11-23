import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  Future<void> _analyze() async {
    if (_textController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.createLog(_textController.text);
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

  Future<void> _showQuickLogDialog() async {
    final controller = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF50594F),
        title: const Text(
          'Quick Log',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
          decoration: const InputDecoration(
            hintText: '한줄로 빡침 기록...',
            hintStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF677365)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF96A694)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu')),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ApiService.createQuickLog(controller.text);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('저장 완료')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('저장 실패: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('저장', style: TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('StressDebugger', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFFB0BFAE)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFB0BFAE)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFFB0BFAE)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '오늘 무슨 일 있었어?',
              style: TextStyle(
                fontFamily: 'TaebaekEunhasu',
                fontSize: 24,
                color: Color(0xFFB0BFAE),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _textController,
              maxLines: 5,
              style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
              decoration: const InputDecoration(
                hintText: '빡친 일 있으면 여기다 써...',
                hintStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
                filled: true,
                fillColor: Color(0xFF50594F),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF677365),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '분석 시작',
                        style: TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          fontSize: 18,
                          color: Color(0xFFB0BFAE),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickLogDialog,
        backgroundColor: const Color(0xFF677365),
        child: const Icon(Icons.add, color: Color(0xFFB0BFAE)),
      ),
    );
  }
}
