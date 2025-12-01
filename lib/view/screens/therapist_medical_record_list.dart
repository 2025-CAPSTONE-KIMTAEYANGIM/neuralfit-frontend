import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';
import 'package:neuralfit_frontend/view/screens/medical_record_detail_screen.dart';
import 'package:neuralfit_frontend/view/screens/therapist_add_record_screen.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_record_viewmodel.dart';

// 진료 기록 상태 Enum
enum AiReportStatus {
  approved, // 승인 완료
  pending, // 승인 대기
  generating, // 생성 중
}

// MedicalRecordListScreen을 StatefulWidget으로 변경하여 상태 관리가 가능하도록 합니다.
class MedicalRecordListScreen extends ConsumerStatefulWidget {
  const MedicalRecordListScreen({super.key});

  @override
  ConsumerState<MedicalRecordListScreen> createState() =>
      _MedicalRecordListScreenState();
}

class _MedicalRecordListScreenState
    extends ConsumerState<MedicalRecordListScreen> {
  // 설정 가능한 최소/최대 년도
  static const int minYear = 2020;
  static const int maxYear = 2030;

  // 요일 변환 함수
  String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  Future<void> _selectMonthYear(
    BuildContext context,
    TherapistRecordState therapistRecordState,
    TherapistRecordViewmodel therapistRecordViewmodel,
  ) async {
    DateTime tempDate = therapistRecordState.selectedTime; // 임시 변수에 현재 선택 값을 저장

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300.0,
          color: Colors.white,
          child: Column(
            children: [
              // 1. 확인/취소 버튼 영역 (와이어프레임 스타일)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // 취소
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        therapistRecordViewmodel.setSelectedTime(
                          DateTime(tempDate.year, tempDate.month, 1),
                        );
                        Navigator.pop(context); // 확인
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 2. 년/월 스피너 영역
              SizedBox(
                height: 200,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoDatePicker(
                        // 와이어프레임처럼 년도와 월만 표시
                        mode: CupertinoDatePickerMode.monthYear,
                        initialDateTime: therapistRecordState.selectedTime,
                        minimumYear: minYear,
                        maximumYear: maxYear,
                        onDateTimeChanged: (DateTime newDateTime) {
                          tempDate = newDateTime; // 임시 변수에 선택 값 저장
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final therapistRecordState = ref.watch(therapistRecordViewmodelProvider);
    final therapistRecordViewmodel = ref.read(
      therapistRecordViewmodelProvider.notifier,
    );

    final formattedMonthYear =
        '${therapistRecordState.selectedTime.year}. ${therapistRecordState.selectedTime.month.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('진료 기록'),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 환자 정보 헤더 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              '${therapistRecordState.currentPatient?.name}님의 진료기록', // PatientInfo 사용
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // 2. 필터링 및 정렬 영역 (커스텀 스피너 버튼)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 캘린더/월 필터 (버튼으로 대체)
                InkWell(
                  onTap: () => _selectMonthYear(
                    context,
                    therapistRecordState,
                    therapistRecordViewmodel,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedMonthYear, // 현재 선택된 년/월 표시
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down), // 드롭다운 아이콘 추가
                    ],
                  ),
                ),

                // 정렬 필터 (기존 유지)
                Row(
                  children: [
                    const Icon(Icons.sort, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    DropdownButton<String>(
                      value: '최신순',
                      items: const [
                        DropdownMenuItem(value: '최신순', child: Text('최신순')),
                        DropdownMenuItem(value: '과거순', child: Text('과거순')),
                      ],
                      onChanged: (String? newValue) {
                        // TODO: 정렬 로직 구현
                      },
                      underline: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. 진료 기록 리스트 영역
          Expanded(
            child: therapistRecordState.medicalRecords.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Text(
                          '진료 기록이 없습니다.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('새로고침'),
                          onPressed: () async {
                            await therapistRecordViewmodel.fetchRecords();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: therapistRecordState.medicalRecords.length,
                    itemBuilder: (context, index) {
                      return MedicalRecordListItem(
                        record: therapistRecordState.medicalRecords[index],
                        getWeekday: _getWeekday,
                        patientInfo: therapistRecordState.currentPatient!,
                      );
                    },
                  ),
          ),
        ],
      ),

      // 4. Floating Action Button (새 기록 추가)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TherapistAddRecordScreen(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class MedicalRecordListItem extends StatelessWidget {
  final MedicalRecord record;
  final String Function(DateTime) getWeekday;
  final PatientInfo patientInfo;

  const MedicalRecordListItem({
    required this.record,
    required this.getWeekday,
    required this.patientInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${record.consultationDate.year}-${record.consultationDate.month.toString().padLeft(2, '0')}-${record.consultationDate.day.toString().padLeft(2, '0')}(${getWeekday(record.consultationDate)})';

    // 🔥 AI 리포트 상태 위젯 생성 함수
    Widget buildAIReportStatus() {
      final ai = record.aiReport;

      if (ai == null) {
        // AI 리포트가 없으면 생성 버튼
        return TextButton(
          onPressed: () {
            // TODO: AI 리포트 생성 API 호출
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text("AI 리포트 생성"),
        );
      }

      // AI Report가 있음 → 승인 상태 표시
      switch (ai.approvalStatus) {
        case "PENDING":
          return const Text(
            "AI 리포트 승인 대기",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          );
        case "APPROVED":
          return const Text(
            "AI 리포트 승인",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          );
        case "REJECTED":
          return const Text(
            "AI 리포트 미승인",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          );
        default:
          return const Text("알 수 없는 상태");
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MedicalRecordDetailScreen(
                  record: record,
                  patientInfo: patientInfo,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '[진료] $formattedDate',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    record.description ?? '',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // 🔥 AI 리포트 상태
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI 리포트 상태",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      buildAIReportStatus(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
