import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'ai_settings_screen.dart';
import 'chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _monthlyStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userInfo = await ApiService.getUserInfo();
      final monthlyStats = await ApiService.getMonthlyStats();
      setState(() {
        _userInfo = userInfo;
        _monthlyStats = monthlyStats;
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

  Future<void> _logout() async {
    await ApiService.clearToken();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _copyInviteCode() {
    if (_userInfo != null) {
      Clipboard.setData(ClipboardData(text: _userInfo!['inviteCode']));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('초대코드 복사됨!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('프로필', style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFFB0BFAE))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: const Color(0xFF50594F),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userInfo?['nickname'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFFB0BFAE),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '@${_userInfo?['username'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFF96A694),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AISettingsScreen()),
                            ).then((_) => _loadData());
                          },
                          icon: const Icon(Icons.settings, color: Color(0xFFB0BFAE)),
                          label: const Text(
                            'AI 설정',
                            style: TextStyle(
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFFB0BFAE),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF677365),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ChatScreen()),
                            );
                          },
                          icon: const Icon(Icons.chat, color: Color(0xFFB0BFAE)),
                          label: const Text(
                            'AI 대화',
                            style: TextStyle(
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFFB0BFAE),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF96A694),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_monthlyStats != null && _monthlyStats!['totalLogs'] > 0) ...[
                    Card(
                      color: const Color(0xFF50594F),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '월간 통계 (최근 30일)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TaebaekEunhasu',
                                color: Color(0xFFB0BFAE),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  '총 로그',
                                  '${_monthlyStats!['totalLogs']}개',
                                  Icons.assignment,
                                ),
                                _buildStatItem(
                                  '평균 빡침',
                                  '${_monthlyStats!['avgAngerLevel']}',
                                  Icons.local_fire_department,
                                ),
                                _buildStatItem(
                                  '평균 예민',
                                  '${_monthlyStats!['avgAnxiety']}',
                                  Icons.psychology,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFF677365)),
                            const SizedBox(height: 16),
                            const Text(
                              '일별 빡침 추이',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TaebaekEunhasu',
                                color: Color(0xFFB0BFAE),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 150,
                              child: _buildDailyChart(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Card(
                    color: const Color(0xFF50594F),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '내 초대코드',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFFB0BFAE),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF677365),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _userInfo?['inviteCode'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TaebaekEunhasu',
                                      color: Color(0xFFB0BFAE),
                                      letterSpacing: 4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: _copyInviteCode,
                                icon: const Icon(Icons.copy, color: Color(0xFF96A694)),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFF677365),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '친구에게 공유하세요!',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFF96A694),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_userInfo?['invitedBy'] != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: const Color(0xFF50594F),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.person_add, color: Color(0xFF96A694)),
                            const SizedBox(width: 12),
                            Text(
                              '${_userInfo!['invitedBy']}님이 초대함',
                              style: const TextStyle(
                                fontFamily: 'TaebaekEunhasu',
                                color: Color(0xFFB0BFAE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF677365),
                      ),
                      child: const Text(
                        '로그아웃',
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
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF96A694), size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'TaebaekEunhasu',
            color: Color(0xFFB0BFAE),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'TaebaekEunhasu',
            color: Color(0xFF96A694),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChart() {
    if (_monthlyStats == null || _monthlyStats!['dailyStats'] == null) {
      return const Center(
        child: Text(
          '데이터 없음',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFF96A694)),
        ),
      );
    }

    final dailyStats = _monthlyStats!['dailyStats'] as List;
    if (dailyStats.isEmpty) {
      return const Center(
        child: Text(
          '데이터 없음',
          style: TextStyle(fontFamily: 'TaebaekEunhasu', color: Color(0xFF96A694)),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: dailyStats.length,
      itemBuilder: (context, index) {
        final stat = dailyStats[index];
        final angerLevel = (stat['avgAngerLevel'] as num).toDouble();
        final date = DateTime.parse(stat['date']);
        
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                angerLevel.toInt().toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'TaebaekEunhasu',
                  color: Color(0xFFB0BFAE),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 30,
                height: angerLevel * 1.2,
                decoration: BoxDecoration(
                  color: angerLevel > 70
                      ? const Color(0xFFD85A5A)
                      : angerLevel > 40
                          ? const Color(0xFFC2A24C)
                          : const Color(0xFF96A694),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.month}/${date.day}',
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'TaebaekEunhasu',
                  color: Color(0xFF677365),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
