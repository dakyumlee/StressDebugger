import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _apiService = ApiService();
  Map<String, dynamic>? _stats;
  List<dynamic> _users = [];
  List<dynamic> _logs = [];
  bool _isLoading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final stats = await _apiService.getAdminStats();
      final users = await _apiService.getAllUsers();
      final logs = await _apiService.getAllLogs();
      setState(() {
        _stats = stats;
        _users = users;
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  DateTime toKST(String dateString) {
    return DateTime.parse(dateString).add(const Duration(hours: 9));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 대시보드', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: [
                      _buildTab('통계', 0),
                      _buildTab('유저', 1),
                      _buildTab('로그', 2),
                    ],
                  ),
                ),
                Expanded(
                  child: _selectedTab == 0
                      ? _buildStatsView()
                      : _selectedTab == 1
                          ? _buildUsersView()
                          : _buildLogsView(),
                ),
              ],
            ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'TaebaekEunhasu',
              color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('전체 유저', '${_stats!['totalUsers']}명', Icons.people),
          _buildStatCard('전체 로그', '${_stats!['totalLogs']}개', Icons.list),
          _buildStatCard('평균 빡침', _stats!['avgAngerLevel'].toStringAsFixed(1), Icons.warning),
          const SizedBox(height: 24),
          const Text(
            '빡침 순위 TOP 10',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu'),
          ),
          const SizedBox(height: 16),
          ...(_stats!['topAngryUsers'] as List).map((user) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      user['avgAngerLevel'].toInt().toString(),
                      style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
                    ),
                  ),
                  title: Text(user['nickname'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                  subtitle: Text('로그: ${user['logCount']}개', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'TaebaekEunhasu', fontSize: 14)),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'TaebaekEunhasu',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(user['nickname'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            subtitle: Text(user['username'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            trailing: Text(
              DateFormat('MM/dd HH:mm').format(date),
              style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
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
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              Icons.warning,
              color: log['angerLevel'] > 70 ? Colors.red : Colors.orange,
            ),
            title: Text(log['text'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            subtitle: Text(
              '${log['username']} | 빡침: ${log['angerLevel']}',
              style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
            ),
            trailing: Text(
              DateFormat('MM/dd HH:mm').format(date),
              style: const TextStyle(fontFamily: 'TaebaekEunhasu', fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
