import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
        const SnackBar(content: Text('모든 필드를 입력해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.register(
        _usernameController.text,
        _passwordController.text,
        _nicknameController.text,
        _inviteCodeController.text.isEmpty ? null : _inviteCodeController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        title: const Text('회원가입', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
        backgroundColor: const Color(0xFF677365),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF96A694),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '회원가입',
                        style: TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          fontSize: 18,
                          color: Color(0xFF262620),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }
}
