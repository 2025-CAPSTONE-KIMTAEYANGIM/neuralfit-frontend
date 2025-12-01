import 'package:dio/dio.dart';
import 'package:neuralfit_frontend/api/repository.dart';
import 'package:neuralfit_frontend/dto/add_medical_record_request.dart';
import 'package:neuralfit_frontend/model/ai_report.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';

class MedicalRecordRepository extends Repository {
  final Dio dio;

  MedicalRecordRepository(this.dio);

  Future<void> addMedicalRecord(
    String accessToken,
    AddMedicalRecordRequest request,
    PatientInfo patient,
  ) async {
    try {
      final response = await dio.post(
        '/record/${patient.id}',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('POST /record ${response.data}');
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('POST /record unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<List<MedicalRecord>> getMedicalRecord(
    String accessToken,
    int patientId,
    int year,
    int month,
  ) async {
    try {
      final response = await dio.get(
        '/record',
        queryParameters: {
          'patient_id': patientId,
          'year': year,
          'month': month,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('GET /record ${response.data}');
      return (response.data as List<dynamic>).map((item) {
        MedicalRecord record = MedicalRecord.fromJson(
          item as Map<String, dynamic>,
        );
        record.aiReport = AIReport(
          medicalRecordId: record.id, // MedicalRecord의 ID를 사용 (가정)
          approvalStatus: 'APPROVED', // 승인
          introduction: '환자님의 최근 인지 검사 결과와 바이오 마커 데이터를 기반으로 작성된 AI 요약 보고서입니다.',
          currentStatus: '현재 인지 기능은 안정적인 상태를 유지하고 있으나, 주의 깊은 관찰이 필요합니다.',
          cognitiveTestInterpretation:
              'MMSE 점수는 이전과 동일하며, MoCA 항목 중 특정 영역에서 미세한 저하가 관찰되었습니다. 이는 일상생활에는 큰 영향을 미치지 않는 경미한 수준입니다.',
          biomarkerInterpretation:
              'ABETA 및 PTAU 수치는 참고 범위 내에 있으나, 전문적인 해석이 필요합니다.',
          summaryOpinion: '전반적으로 인지 상태는 양호하지만, 의료진의 최종 승인 및 검토가 필요합니다.',
          recommendations: '다음 진료 전까지 매일 20분씩 새로운 단어 외우기 활동을 수행해 주십시오.',
          createdAt: DateTime.now(), // 현재 시간으로 설정
          updatedAt: DateTime.now(), // 현재 시간으로 설정
        );
        return record;
      }).toList();
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('GET /record unknown error: $e');
      throw handleUnknownException(e);
    }
  }
}
