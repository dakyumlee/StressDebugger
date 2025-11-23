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
        const SnackBar(
          content: Text('모든 필수 항목을 입력해주세요', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
          backgroundColor: Color(0xFF677365),
        ),
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
        SnackBar(
          content: Text('회원가입 실패: $e', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
          backgroundColor: Colors.red.shade700,
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0BFAE)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontFamily: 'TaebaekEunhasu',
            color: Color(0xFFB0BFAE),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '필수 정보',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontSize: 18,
                  color: Color(0xFFB0BFAE),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                decoration: InputDecoration(
                  labelText: '아이디',
                  labelStyle: const TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                  filled: true,
                  fillColor: const Color(0xFF50594F),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF677365), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF96A694), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: const TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                  filled: true,
                  fillColor: const Color(0xFF50594F),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF677365), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF96A694), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                decoration: InputDecoration(
                  labelText: '닉네임',
                  labelStyle: const TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                  filled: true,
                  fillColor: const Color(0xFF50594F),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF677365), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF96A694), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '선택 정보',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontSize: 18,
                  color: Color(0xFF96A694),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _inviteCodeController,
                style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                decoration: InputDecoration(
                  labelText: '초대코드',
                  hintText: '있으면 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF677365), fontFamily: 'TaebaekEunhasu'),
                  labelStyle: const TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu', fontSize: 16),
                  filled: true,
                  fillColor: const Color(0xFF50594F),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF677365), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF96A694), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF677365),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          '회원가입',
                          style: TextStyle(
                            fontFamily: 'TaebaekEunhasu',
                            fontSize: 18,
                            color: Color(0xFFB0BFAE),
                            fontWeight: FontWeight.bold,
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
