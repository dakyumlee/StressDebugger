import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({Key? key}) : super(key: key);

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  bool _isLoading = true;
  String _humorPreference = '병맛';
  int _sensitivityLevel = 5;
  String _preferredMessageLength = '중간';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ApiService.getUserProfile();
      setState(() {
        _humorPreference = profile['humorPreference'] ?? '병맛';
        _sensitivityLevel = profile['sensitivityLevel'] ?? 5;
        _preferredMessageLength = profile['preferredMessageLength'] ?? '중간';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    try {
      await ApiService.updateUserProfile(
        humorPreference: _humorPreference,
        sensitivityLevel: _sensitivityLevel,
        preferredMessageLength: _preferredMessageLength,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI 설정 저장 완료!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        title: const Text('나만의 AI 설정', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
        backgroundColor: const Color(0xFF677365),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('저장', style: TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu')),
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
                  _buildSection(
                    '위로 스타일',
                    _buildHumorSelector(),
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    '감정 민감도',
                    _buildSensitivitySlider(),
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    '메시지 길이',
                    _buildLengthSelector(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'TaebaekEunhasu',
            color: Color(0xFFB0BFAE),
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildHumorSelector() {
    return Wrap(
      spacing: 12,
      children: ['병맛', '따뜻', '시니컬', '밝음'].map((style) {
        return ChoiceChip(
          label: Text(style, style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
          selected: _humorPreference == style,
          onSelected: (selected) {
            if (selected) setState(() => _humorPreference = style);
          },
          selectedColor: const Color(0xFF96A694),
          backgroundColor: const Color(0xFF50594F),
          labelStyle: TextStyle(
            color: _humorPreference == style ? const Color(0xFF262620) : const Color(0xFFB0BFAE),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSensitivitySlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('쿨하게', style: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu')),
            Text('$_sensitivityLevel', style: const TextStyle(color: Color(0xFFB0BFAE), fontFamily: 'TaebaekEunhasu', fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('따뜻하게', style: TextStyle(color: Color(0xFF96A694), fontFamily: 'TaebaekEunhasu')),
          ],
        ),
        Slider(
          value: _sensitivityLevel.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: const Color(0xFF96A694),
          inactiveColor: const Color(0xFF50594F),
          onChanged: (value) => setState(() => _sensitivityLevel = value.toInt()),
        ),
      ],
    );
  }

  Widget _buildLengthSelector() {
    return Wrap(
      spacing: 12,
      children: ['짧게', '중간', '길게'].map((length) {
        return ChoiceChip(
          label: Text(length, style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
          selected: _preferredMessageLength == length,
          onSelected: (selected) {
            if (selected) setState(() => _preferredMessageLength = length);
          },
          selectedColor: const Color(0xFF96A694),
          backgroundColor: const Color(0xFF50594F),
          labelStyle: TextStyle(
            color: _preferredMessageLength == length ? const Color(0xFF262620) : const Color(0xFFB0BFAE),
          ),
        );
      }).toList(),
    );
  }
}
