import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  const LoginScreen({super.key, required this.isLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _apiService = ApiService();
  late bool _isLogin;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _apiService.login(_usernameController.text, _passwordController.text);
      } else {
        await _apiService.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? '로그인' : '회원가입',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF96A694),
                  fontFamily: 'TaebaekEunhasu',
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _usernameController,
                style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '아이디',
                  labelStyle: TextStyle(fontFamily: 'TaebaekEunhasu'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLogin)
                TextField(
                  controller: _emailController,
                  style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    labelStyle: TextStyle(fontFamily: 'TaebaekEunhasu'),
                    border: OutlineInputBorder(),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: TextStyle(fontFamily: 'TaebaekEunhasu'),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: const Color(0xFFB0BFAE),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Color(0xFFB0BFAE))
                      : Text(
                          _isLogin ? '로그인' : '회원가입',
                          style: const TextStyle(fontSize: 16, fontFamily: 'TaebaekEunhasu'),
                        ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? '회원가입' : '로그인으로 돌아가기',
                  style: const TextStyle(fontFamily: 'TaebaekEunhasu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
