import 'package:flutter/material.dart';

class InsightDetailPage extends StatefulWidget {
  // 현재 인지 활동 인덱스를 받을 수 있도록 파라미터 추가
  final int initialActivityIndex;

  const InsightDetailPage({super.key, this.initialActivityIndex = 0});

  @override
  State<InsightDetailPage> createState() => _InsightDetailPageState();
}

class _InsightDetailPageState extends State<InsightDetailPage> {
  final List<String> dailyActivities = const [
    "오늘의 활동: 새로운 요리 레시피를 외워보세요.",
    "오늘의 활동: 어제 만난 사람 3명의 이름을 기억해 보세요.",
    "오늘의 활동: 퍼즐 게임을 30분간 집중해서 풀어보세요.",
    "오늘의 활동: 20분간 산책하며 주변 사물 5가지의 특징을 상세히 관찰하세요.",
  ];

  final List<String> recommendationTitles = const [
    "기억력 향상 훈련",
    "실행 기능 활성화 게임",
    "집중력 강화 명상 가이드",
  ];

  late int _currentActivityIndex;

  @override
  void initState() {
    super.initState();
    // 초기 인덱스를 받아옴 (없으면 0)
    _currentActivityIndex =
        widget.initialActivityIndex % dailyActivities.length;
  }

  // 데이터 요약 카드를 빌드하는 헬퍼 함수
  Widget _buildDataSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 추천 활동 목록을 빌드하는 헬퍼 함수
  Widget _buildRecommendationItem(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.play_circle_outline, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print('추천 활동 시작: $title');
        // TODO: 해당 활동 페이지로 이동
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 활동의 상세 설명
    final currentActivity = dailyActivities[_currentActivityIndex];
    final activityTitle = currentActivity.split(':')[1].trim();

    return Scaffold(
      appBar: AppBar(title: const Text('AI 맞춤 인지 가이드'), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. 오늘의 활동 요약 카드 (상세 버전) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 집중 목표',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activityTitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AI 분석 결과, 현재 환자분의 ${activityTitle.contains('레시피')
                        ? '기억력'
                        : activityTitle.contains('이름')
                        ? '언어 능력'
                        : '실행 기능'} 강화를 위해 이 활동이 가장 효과적입니다.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const Divider(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('활동 시작 버튼 클릭');
                        // TODO: 활동 시작 페이지로 이동
                      },
                      icon: const Icon(Icons.star, color: Colors.white),
                      label: const Text(
                        '지금 활동 시작하기',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. 최근 데이터 분석 요약 ---
            const Text(
              '최근 인지 데이터 요약',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildDataSummaryCard('어제 활동 완료율', '85%', Colors.deepPurple),
                const SizedBox(width: 10),
                _buildDataSummaryCard('지난 주 대비 MMSE', '+2점', Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildDataSummaryCard('주요 개선 영역', '기억력', Colors.orange),
                const SizedBox(width: 10),
                _buildDataSummaryCard('다음 검사까지', 'D-35', Colors.red),
              ],
            ),

            const SizedBox(height: 30),

            // --- 3. 추천 활동 목록 ---
            const Text(
              '추가 추천 활동',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: recommendationTitles
                    .map(
                      (title) => _buildRecommendationItem(
                        title,
                        'AI가 환자 맞춤형으로 선별한 추가 훈련입니다.',
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
