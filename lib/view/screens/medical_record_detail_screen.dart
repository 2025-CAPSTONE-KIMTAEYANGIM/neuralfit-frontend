import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/model/ai_report.dart';
import 'package:neuralfit_frontend/model/app_user_info.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';

class MedicalRecordDetailScreen extends StatelessWidget {
  final MedicalRecord record;
  final AppUserInfo patientInfo;

  const MedicalRecordDetailScreen({
    super.key,
    required this.record,
    required this.patientInfo,
  });

  // --- 헬퍼 위젯: 데이터 항목 ---
  Widget _buildDataItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 헬퍼 위젯: 섹션 제목 ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷팅
    final formattedDate =
        '${record.consultationDate.year}-${record.consultationDate.month.toString().padLeft(2, '0')}-${record.consultationDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('${record.diagnosis ?? "미정"} 진료 기록'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. 기본 정보 및 진단 ---
            Text(
              '${patientInfo.name} 환자 진료 기록',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),

            _buildSectionTitle('📅 진료 및 기본 정보'),
            _buildDataItem('진료 일자', formattedDate),
            _buildDataItem(
              '진단 (DX)',
              record.diagnosis ?? '데이터 없음',
              color: Colors.deepOrange,
            ),
            _buildDataItem('의료진 ID', record.therapistId.toString()),
            _buildDataItem(
              '생성일',
              '${record.createdAt.year}-${record.createdAt.month.toString().padLeft(2, '0')}-${record.createdAt.day.toString().padLeft(2, '0')}',
            ),

            const SizedBox(height: 10),

            // --- 2. 메모 및 코멘트 ---
            _buildSectionTitle('📝 메모 및 코멘트'),
            _buildDataItem('의료진 메모', record.description ?? '특이사항 없음'),
            _buildDataItem('환자 코멘트', record.patientComment ?? '기록 없음'),

            // --- 3. 인지 기능 검사 결과 ---
            _buildSectionTitle('🧠 인지 기능 검사 결과'),
            _buildDataItem('MOCA', record.moca?.toString() ?? '-'),
            _buildDataItem('MMSE', record.mmse?.toString() ?? '-'),
            _buildDataItem('FAQ', record.faq?.toString() ?? '-'),
            _buildDataItem('LDELTOTAL', record.ldelTotal?.toString() ?? '-'),
            _buildDataItem('ADAS13', record.adas13?.toString() ?? '-'),
            _buildDataItem('ECOG Pt Mem', record.ecogPtMem?.toString() ?? '-'),
            _buildDataItem(
              'ECOG Pt Total',
              record.ecogPtTotal?.toString() ?? '-',
            ),

            // --- 4. 생체 마커 데이터 ---
            _buildSectionTitle('🧪 생체 마커 데이터'),
            _buildDataItem('ABETA', record.abeta?.toString() ?? '-'),
            _buildDataItem('PTAU', record.ptau?.toString() ?? '-'),

            // --- 5. AI 리포트 ---
            _buildSectionTitle('🤖 AI 리포트'),
            const SizedBox(height: 5),

            record.aiReport == null
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AI Report가 생성되지 않았거나, 데이터에 포함되지 않았습니다.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : _buildAiReportSection(record.aiReport!),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- 헬퍼 위젯: AI 리포트 상세 ---
  Widget _buildAiReportSection(AIReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataItem(
          '승인 상태',
          report.approvalStatus,
          color: report.approvalStatus == 'APPROVED'
              ? Colors.green
              : Colors.orange,
        ),
        const SizedBox(height: 10),

        _buildReportDetailCard('도입 (Introduction)', report.introduction),
        _buildReportDetailCard('현재 상태 요약', report.currentStatus),
        _buildReportDetailCard('인지 검사 해석', report.cognitiveTestInterpretation),
        _buildReportDetailCard('생체 마커 해석', report.biomarkerInterpretation),
        _buildReportDetailCard(
          '최종 소견 (요약)',
          report.summaryOpinion,
          isImportant: true,
        ),
        _buildReportDetailCard('추천 활동', report.recommendations),
      ],
    );
  }

  // --- 헬퍼 위젯: AI 리포트 내용 카드 ---
  Widget _buildReportDetailCard(
    String title,
    String content, {
    bool isImportant = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: isImportant ? 4 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: isImportant ? Colors.blue.shade50 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isImportant ? Colors.blueAccent : Colors.black87,
                ),
              ),
              const Divider(height: 15, thickness: 0.5),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
