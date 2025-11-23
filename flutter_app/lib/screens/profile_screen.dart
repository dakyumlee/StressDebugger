import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await ApiService.getUserInfo();
      setState(() {
        _userInfo = userInfo;
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
}
