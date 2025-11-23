import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await ApiService.getHistory();
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
        backgroundColor: const Color(0xFF50594F),
        title: const Text(
          '로그 수정',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE)),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
          decoration: const InputDecoration(
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
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu')),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ApiService.updateLog(log['id'], controller.text);
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('수정 실패: $e')),
                  );
                }
              }
            },
            child: const Text('저장', style: TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu')),
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
        backgroundColor: const Color(0xFF50594F),
        title: const Text('삭제 확인', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
        content: const Text('이 로그를 삭제하시겠습니까?', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red, fontFamily: 'TaebaekEunhasu')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteLog(id);
        _loadLogs();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제 완료')),
          );
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

  DateTime toKST(String dateString) {
    return DateTime.parse(dateString).add(const Duration(hours: 9));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('히스토리', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? const Center(
                  child: Text(
                    '기록이 없습니다',
                    style: TextStyle(
                      fontFamily: 'TaebaekEunhasu',
                      fontSize: 18,
                      color: Color(0xFF96A694),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    final date = toKST(log['createdAt']);
                    final isQuickLog = log['logType'] == 'QUICK';

                    return Card(
                      color: const Color(0xFF50594F),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          isQuickLog ? Icons.flash_on : Icons.warning,
                          color: isQuickLog 
                              ? const Color(0xFF96A694) 
                              : (log['angerLevel'] > 70 ? Colors.red : Colors.orange),
                        ),
                        title: Row(
                          children: [
                            if (isQuickLog) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF677365),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'QUICK',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'TaebaekEunhasu',
                                    color: Color(0xFFB0BFAE),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                log['text'],
                                style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          isQuickLog
                              ? DateFormat('MM/dd HH:mm').format(date)
                              : '빡침: ${log['angerLevel']} | ${DateFormat('MM/dd HH:mm').format(date)}',
                          style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFF96A694)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFF96A694)),
                              onPressed: () => _showEditDialog(log),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLog(log['id']),
                            ),
                          ],
                        ),
                        onTap: isQuickLog
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(result: log),
                                  ),
                                );
                              },
                      ),
                    );
                  },
                ),
    );
  }
}
