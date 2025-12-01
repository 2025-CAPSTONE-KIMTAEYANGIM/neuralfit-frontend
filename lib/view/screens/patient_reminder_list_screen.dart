import 'package:flutter/material.dart';

// 리마인더 데이터를 위한 모델 정의 (간단화)
class ReminderItem {
  final IconData icon;
  final String timeTitle;
  final String description;

  ReminderItem({
    required this.icon,
    required this.timeTitle,
    required this.description,
  });
}

class ReminderListPage extends StatelessWidget {
  ReminderListPage({super.key});

  // 목업 데이터
  final List<ReminderItem> _mockReminders = [
    // 오늘 리마인더
    ReminderItem(
      icon: Icons.medication,
      timeTitle: '오후 6시 약 복용',
      description: '치매약 1정',
    ),
    ReminderItem(
      icon: Icons.directions_run,
      timeTitle: '오전 10시 운동',
      description: '30분 걷기',
    ),
    ReminderItem(
      icon: Icons.dinner_dining,
      timeTitle: '오후 12시 점심 식사',
      description: '균형 잡힌 식단',
    ),
    // 다가오는 리마인더
    ReminderItem(
      icon: Icons.calendar_today,
      timeTitle: '2025년 10월 5일',
      description: '정기 인지 기능 검사',
    ),
    ReminderItem(
      icon: Icons.phone,
      timeTitle: '2025년 10월 7일',
      description: '가족과의 영상 통화',
    ),
    ReminderItem(
      icon: Icons.local_hospital,
      timeTitle: '2025년 10월 15일',
      description: '병원 진료 예약',
    ),
  ];

  // 리마인더 항목을 빌드하는 위젯 (제공된 스타일 기반)
  Widget _buildReminderItem(
    BuildContext context,
    ReminderItem item,
    bool isToday,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isToday ? Colors.blueAccent : Colors.grey,
          size: 30,
        ),
        title: Text(
          item.timeTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? Colors.black : Colors.black87,
          ),
        ),
        subtitle: Text(
          item.description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: isToday
            ? IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                onPressed: () {
                  // TODO: 리마인더 완료 처리 로직
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.timeTitle} 완료됨!')),
                  );
                },
              )
            : null,
        onTap: () {
          // TODO: 리마인더 상세/수정 페이지로 이동
          print('상세 보기: ${item.timeTitle}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 오늘/다가오는 리마인더 분리 (목업 데이터에서 간단히 분리)
    final todayReminders = _mockReminders.take(3).toList();
    final upcomingReminders = _mockReminders.skip(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('전체 리마인더'), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘 리마인더 섹션
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                '오늘의 리마인더',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...todayReminders
                .map((item) => _buildReminderItem(context, item, true))
                .toList(),

            const Divider(height: 30),

            // 다가오는 리마인더 섹션
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                '다가오는 리마인더',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...upcomingReminders
                .map((item) => _buildReminderItem(context, item, false))
                .toList(),

            const SizedBox(height: 80), // FAB 공간 확보
          ],
        ),
      ),

      // 새 리마인더 추가 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 새 리마인더 추가 페이지로 이동
          print('새 리마인더 추가');
        },
        label: const Text('리마인더 추가', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
