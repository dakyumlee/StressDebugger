import 'package:flutter/material.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final forensic = jsonDecode(result['forensicResult']);
    
    return Scaffold(
      appBar: AppBar(title: const Text('분석 결과', style: TextStyle(fontFamily: 'TaebaekEunhasu'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              context,
              '빡침 포렌식',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '빡침 지수: ${result['angerLevel']}/100',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu'),
                  ),
                  const SizedBox(height: 8),
                  Text('예민 지수: ${result['anxiety']}/100', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                  Text('기술 요인: ${result['techFactor']}/100', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                  Text('인간 요인: ${result['humanFactor']}/100', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                  const SizedBox(height: 16),
                  Text(
                    '주요 원인:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'TaebaekEunhasu'),
                  ),
                  ...List.generate(
                    (forensic['top_causes'] as List).length,
                    (i) => Text('${i + 1}. ${forensic['top_causes'][i]}', style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    forensic['verdict'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TaebaekEunhasu',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              '반박불가 변명',
              Text(result['justification'], style: const TextStyle(fontFamily: 'TaebaekEunhasu')),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              '위로의 한마디',
              Text(
                result['consolation'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontFamily: 'TaebaekEunhasu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget content) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'TaebaekEunhasu',
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}
