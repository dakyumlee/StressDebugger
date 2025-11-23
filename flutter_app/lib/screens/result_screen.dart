import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  DateTime toKST(String dateString) {
    return DateTime.parse(dateString).add(const Duration(hours: 9));
  }

  @override
  Widget build(BuildContext context) {
    final date = toKST(result['createdAt']);
    final isQuickLog = result['logType'] == 'QUICK';

    return Scaffold(
      backgroundColor: const Color(0xFF262620),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50594F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0BFAE)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '분석 결과',
          style: TextStyle(
            fontFamily: 'TaebaekEunhasu',
            color: Color(0xFFB0BFAE),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isQuickLog) ...[
              Card(
                color: const Color(0xFF50594F),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '빡침 포렌식',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFFB0BFAE),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('빡침 지수', result['angerLevel'], Colors.red),
                      _buildStatRow('예민 지수', result['anxiety'], Colors.orange),
                      _buildStatRow('기술 요인', result['techFactor'], const Color(0xFF96A694)),
                      _buildStatRow('인간 요인', result['humanFactor'], const Color(0xFF677365)),
                      const SizedBox(height: 16),
                      const Text(
                        '주요 원인:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFFB0BFAE),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result['forensicResult'] ?? '분석 중...',
                        style: const TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFF96A694),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFF50594F),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '반박불가 변명',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFFB0BFAE),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result['justification'] ?? '생성 중...',
                        style: const TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFF96A694),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFF50594F),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '위로의 한마디',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFFB0BFAE),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result['consolation'] ?? '작성 중...',
                        style: const TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          color: Color(0xFFB0BFAE),
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                color: const Color(0xFF50594F),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on, color: Color(0xFF96A694), size: 28),
                          const SizedBox(width: 8),
                          const Text(
                            'Quick Log',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'TaebaekEunhasu',
                              color: Color(0xFFB0BFAE),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        result['text'],
                        style: const TextStyle(
                          fontFamily: 'TaebaekEunhasu',
                          fontSize: 16,
                          color: Color(0xFFB0BFAE),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: Text(
                DateFormat('yyyy년 MM월 dd일 HH:mm').format(date),
                style: const TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  color: Color(0xFF677365),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  color: Color(0xFFB0BFAE),
                ),
              ),
              Text(
                '$value/100',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: const Color(0xFF677365),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
