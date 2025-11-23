import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import 'result_screen.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  List<dynamic> _logs = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final logs = await _apiService.getMyLogs();
      final stats = await _apiService.getWeeklyStats();
      setState(() {
        _logs = logs;
        _stats = stats;
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
        title: const Text('프로필', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminScreen()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_stats != null) ...[
                    _buildStatsCard(),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    '내 히스토리',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu'),
                  ),
                  const SizedBox(height: 16),
                  ..._logs.map((log) => _buildLogCard(log)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    final weeklyStats = _stats!['weeklyStats'] as List;
    
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '주간 통계',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu'),
            ),
            const SizedBox(height: 12),
            Text('총 로그: ${_stats!['totalLogs']}개', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            Text('평균 빡침: ${_stats!['avgAngerLevel'].toStringAsFixed(1)}', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            Text('기술 vs 인간: ${_stats!['techVsHumanRatio'].toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            const SizedBox(height: 16),
            if (weeklyStats.isNotEmpty) ...[
              const Text('주간 빡침 그래프', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu')),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weeklyStats.length,
                  itemBuilder: (context, index) {
                    final stat = weeklyStats[index];
                    final angerLevel = stat['avgAngerLevel'];
                    final date = DateTime.parse(stat['date']);
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            angerLevel.toInt().toString(),
                            style: const TextStyle(fontSize: 12, fontFamily: 'TaebaekEunhasu'),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: angerLevel * 1.5,
                            decoration: BoxDecoration(
                              color: angerLevel > 70 ? Colors.red : angerLevel > 40 ? Colors.orange : Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(fontSize: 10, fontFamily: 'TaebaekEunhasu'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    final date = toKST(log['createdAt']);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: log),
            ),
          );
        },
        child: ListTile(
          title: Text(log['text'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
          subtitle: Text(
            '빡침: ${log['angerLevel']} | ${DateFormat('MM/dd HH:mm').format(date)}',
            style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
          ),
          trailing: Icon(
            Icons.warning,
            color: log['angerLevel'] > 70 ? Colors.red : Colors.orange,
          ),
        ),
      ),
    );
  }
}
