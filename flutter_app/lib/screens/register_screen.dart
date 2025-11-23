import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_usernameController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필수 항목을 입력해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.register(
        _usernameController.text,
        _passwordController.text,
        _nicknameController.text,
        invitedBy: _inviteCodeController.text.isEmpty ? null : _inviteCodeController.text,
      );

      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50594F),
        title: const Text('회원가입', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '아이디',
                  labelStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF677365)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF96A694)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF677365)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF96A694)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  labelStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF677365)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF96A694)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _inviteCodeController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '초대코드 (선택)',
                  labelStyle: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF677365)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF96A694)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF677365),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          '회원가입',
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
      ),
    );
  }
}
