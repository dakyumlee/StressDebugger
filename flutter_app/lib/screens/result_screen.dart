import 'package:flutter/material.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forensicData = _parseForensicResult(result['forensicResult']);
    
    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        title: const Text('분석 결과', style: TextStyle(fontFamily: 'TaebaekEunhasu')),
        backgroundColor: const Color(0xFF677365),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStressCard(forensicData),
            const SizedBox(height: 20),
            _buildJustificationCard(),
            const SizedBox(height: 20),
            _buildConsolationCard(),
            const SizedBox(height: 20),
            Text(
              result['createdAt'] ?? '',
              style: const TextStyle(color: Color(0xFF96A694), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _parseForensicResult(dynamic forensicResult) {
    if (forensicResult is String) {
      try {
        return jsonDecode(forensicResult);
      } catch (e) {
        return {'top_causes': [], 'verdict': '분석 결과 없음'};
      }
    } else if (forensicResult is Map) {
      return Map<String, dynamic>.from(forensicResult);
    }
    return {'top_causes': [], 'verdict': '분석 결과 없음'};
  }

  Widget _buildStressCard(Map<String, dynamic> forensicData) {
    final topCauses = forensicData['top_causes'] as List? ?? [];
    final verdict = forensicData['verdict'] ?? '오늘 빡침은 정상 반응입니다';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF50594F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '빡침 포렌식',
            style: TextStyle(
              color: Color(0xFFB0BFAE),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'TaebaekEunhasu',
            ),
          ),
          const SizedBox(height: 20),
          _buildBar('빡침 지수', result['angerLevel'] ?? 0, const Color(0xFFD85A5A)),
          const SizedBox(height: 10),
          _buildBar('예민 지수', result['anxiety'] ?? 0, const Color(0xFFC2A24C)),
          const SizedBox(height: 10),
          _buildBar('기술 요인', result['techFactor'] ?? 0, const Color(0xFF96A694)),
          const SizedBox(height: 10),
          _buildBar('인간 요인', result['humanFactor'] ?? 0, const Color(0xFF677365)),
          const SizedBox(height: 20),
          const Text(
            '주요 원인:',
            style: TextStyle(
              color: Color(0xFFB0BFAE),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'TaebaekEunhasu',
            ),
          ),
          const SizedBox(height: 8),
          ...topCauses.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${entry.key + 1}. ${entry.value}',
              style: const TextStyle(color: Color(0xFF96A694), fontSize: 14),
            ),
          )),
          const SizedBox(height: 12),
          Text(
            '판정: $verdict',
            style: const TextStyle(
              color: Color(0xFFB0BFAE),
              fontSize: 14,
              fontFamily: 'TaebaekEunhasu',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF96A694), fontSize: 14)),
            Text('$value/100', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: const Color(0xFF262620),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildJustificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF50594F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '반박불가 변명',
            style: TextStyle(
              color: Color(0xFFB0BFAE),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'TaebaekEunhasu',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result['justification'] ?? '',
            style: const TextStyle(color: Color(0xFF96A694), fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildConsolationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF50594F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '위로의 한마디',
            style: TextStyle(
              color: Color(0xFFB0BFAE),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'TaebaekEunhasu',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result['consolation'] ?? '',
            style: const TextStyle(color: Color(0xFF96A694), fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}
