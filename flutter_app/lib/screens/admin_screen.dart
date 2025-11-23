import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<dynamic> _users = [];
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final users = await ApiService.getAdminUsers();
      final logs = await ApiService.getAdminLogs();
      setState(() {
        _users = users;
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('데이터 로드 실패: $e')),
        );
      }
    }
  }

  Future<void> _deleteUser(String username) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('사용자 삭제', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
        content: Text('$username 사용자를 삭제하시겠습니까?', style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
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
        await ApiService.deleteUser(username);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사용자 삭제 완료')),
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

  Future<void> _deleteLog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('로그 삭제', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
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
        await ApiService.deleteAnyLog(id);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그 삭제 완료')),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF262620),
        appBar: AppBar(
          backgroundColor: const Color(0xFF50594F),
          title: const Text('관리자', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
          bottom: const TabBar(
            indicatorColor: Color(0xFF96A694),
            labelColor: Color(0xFFB0BFAE),
            unselectedLabelColor: Color(0xFF96A694),
            tabs: [
              Tab(child: Text('회원', style: TextStyle(fontFamily: 'TaebaekEunhasu'))),
              Tab(child: Text('로그', style: TextStyle(fontFamily: 'TaebaekEunhasu'))),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildUsersView(),
                  _buildLogsView(),
                ],
              ),
      ),
    );
  }

  Widget _buildUsersView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        final date = toKST(user['createdAt']);
        return Card(
          color: const Color(0xFF50594F),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF96A694)),
            title: Text(user['nickname'] ?? user['username'], style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
            subtitle: Text(
              '${user['username']} | ${DateFormat('MM/dd HH:mm').format(date)}',
              style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFF96A694)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(user['username']),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final date = toKST(log['createdAt']);
        final isQuickLog = log['logType'] == 'QUICK';
        
        return Card(
          color: const Color(0xFF50594F),
          margin: const EdgeInsets.only(bottom: 8),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              '${log['username']} | ${isQuickLog ? '' : '빡침: ${log['angerLevel']} | '}${DateFormat('MM/dd HH:mm').format(date)}',
              style: const TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFF96A694)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteLog(log['id']),
            ),
          ),
        );
      },
    );
  }
}
