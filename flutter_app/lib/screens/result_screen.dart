import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/stress_log.dart';

class ResultScreen extends StatelessWidget {
  final StressLog log;

  const ResultScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '분석 결과',
          style: TextStyle(
            fontFamily: 'TaebaekEunhasu',
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreCard('빡침 지수', log.angerLevel ?? 0),
            const SizedBox(height: 16),
            _buildScoreCard('예민 지수', log.anxiety ?? 0),
            const SizedBox(height: 16),
            _buildScoreCard('기술 스트레스', log.techFactor ?? 0),
            const SizedBox(height: 16),
            _buildScoreCard('인간 스트레스', log.humanFactor ?? 0),
            const SizedBox(height: 32),
            if (log.forensicResult != null) ...[
              const Text(
                '빡침 원인 포렌식',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (log.forensicResult!['top_causes'] != null)
                      ...List.generate(
                        (log.forensicResult!['top_causes'] as List).length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '${index + 1}위: ${log.forensicResult!['top_causes'][index]}',
                            style: const TextStyle(
                              fontFamily: 'TaebaekEunhasu',
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      log.forensicResult!['verdict'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'TaebaekEunhasu',
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            if (log.justification != null) ...[
              const Text(
                '반박불가 정당화',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  log.justification!,
                  style: const TextStyle(
                    fontFamily: 'TaebaekEunhasu',
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            if (log.consolation != null) ...[
              const Text(
                '위로의 한마디',
                style: TextStyle(
                  fontFamily: 'TaebaekEunhasu',
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  log.consolation!,
                  style: const TextStyle(
                    fontFamily: 'TaebaekEunhasu',
                    color: AppColors.dark,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontFamily: 'TaebaekEunhasu',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'TaebaekEunhasu',
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontFamily: 'TaebaekEunhasu',
              fontSize: 24,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
