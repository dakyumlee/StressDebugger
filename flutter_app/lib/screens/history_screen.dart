import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/colors.dart';
import '../services/api_service.dart';
import '../models/stress_log.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _apiService = ApiService();
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await _apiService.getMyLogs();
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그 로드 실패: $e')),
        );
      }
    }
  }

  Future<void> _showEditDialog(dynamic log) async {
    final controller = TextEditingController(text: log['text']);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '로그 수정',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: '수정할 내용을 입력하세요',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _apiService.updateLog(log['id'], controller.text);
                if (context.mounted) {
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('수정 완료')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('수정 실패: $e')),
                  );
                }
              }
            },
            child: const Text('저장', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
          ),
        ],
      ),
    );
    
    if (result == true) {
      _loadLogs();
    }
  }

  Future<void> _deleteLog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          '로그 삭제',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: AppColors.textPrimary),
        ),
        content: const Text(
          '정말 삭제하시겠습니까?',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.deleteLog(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제 완료')),
          );
          _loadLogs();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '히스토리',
          style: TextStyle(
            fontFamily: 'TaebaekEunhasu',
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : _logs.isEmpty
              ? const Center(
                  child: Text(
                    '아직 기록이 없습니다',
                    style: TextStyle(
                      fontFamily: 'TaebaekEunhasu',
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return _buildLogCard(log);
                  },
                ),
    );
  }

  Widget _buildLogCard(dynamic log) {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final dateStr = log['createdAt'] != null
        ? dateFormat.format(DateTime.parse(log['createdAt']).add(const Duration(hours: 9)))
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResultScreen(log: log),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontFamily: 'TaebaekEunhasu',
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '빡침: ${log['angerLevel'] ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'TaebaekEunhasu',
                        color: AppColors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: AppColors.textSecondary),
                      onPressed: () => _showEditDialog(log),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () => _deleteLog(log['id']),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              log['text'].toString().length > 100
                  ? '${log['text'].toString().substring(0, 100)}...'
                  : log['text'].toString(),
              style: const TextStyle(
                fontFamily: 'TaebaekEunhasu',
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
