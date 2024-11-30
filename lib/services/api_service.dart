import 'dart:io';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://anasprograme3.pythonanywhere.com';
  
  // final String baseUrl = 'https://TAARAF.pythonanywhere.com';


  Future<Response> registerStudent(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/register_student', data: data);
    return response;
  }

  Future<String> registerStudentFaceRepresentation(
      int student_id, List<String> images) async {
    try {
      final response = await _dio.post(
        '$baseUrl/register_student_face_representation/$student_id',
        data: {
          'images': images,
        },
      );
      return response.data['message'];
    } catch (e) {
      throw Exception('Failed to register student: $e');
    }
  }

  Future<Response> markAttendance(
      String base64Image, int attendanceRecordId) async {
    final response = await _dio.post(
      '$baseUrl/mark_attendance/$attendanceRecordId',
      data: {'image': base64Image},
    );
    return response;
  }

  Future<Response> saveStudentStudyInfo(Map<String, dynamic> data) async {
    final response =
        await _dio.post('$baseUrl/save_student_study_info', data: data);

    if (response.statusCode != 201) {
      throw Exception('Failed to save student study info');
    }
    return response;
  }

  // Future<void> saveStudentCourse(
  //     int studentStudyInfoId, Map<String, dynamic> data) async {
  //   try {
  //     final response = await _dio
  //         .post('$baseUrl/save_student_course/$studentStudyInfoId', data: data);

  //     if (response.statusCode != 201) {
  //       throw Exception('Failed to save student course');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to save student course: $e');
  //   }
  // }

  Future<Response> saveStudentCourse(int studentStudyInfoId, Map<String, dynamic> data) async {
    return await _dio.post(
      '$baseUrl/save_student_course/$studentStudyInfoId',
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>> getStudentCourses(int studentId) async {
    try {
      final response =
          await _dio.get('$baseUrl/get_student_courses/$studentId');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((course) => course as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to get student courses');
      }
    } catch (e) {
      throw Exception('Failed to get student courses: $e');
    }
  }

  Future<Response> registerFaculty(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/register_faculty', data: data);
    return response;
  }

  Future<Response> loginStudent(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/login_student', data: data);
    return response;
  }

  Future<Response> loginFaculty(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/login_faculty', data: data);
    return response;
  }

  Future<Response> addFacultyStudyInfo(
      int facultyId, Map<String, dynamic> data) async {
    try {
      final response = await _dio
          .post('$baseUrl/add_faculty_study_info/$facultyId', data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to add faculty study info');
    }
  }

  Future<void> deleteFacultyStudyInfo(int id) async {
    try {
      final response = await _dio.delete(
        '$baseUrl/delete_faculty_study_info/$id',
      );
      print('Deleted: ${response.data}');
    } catch (e) {
      throw Exception('Failed to delete faculty study info');
    }
  }

  Future<Response> updateFacultyStudyInfo(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '$baseUrl/update_faculty_study_info/$id',
        data: data,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to update faculty study info: $error');
    }
  }

  Future<Response> getAllUsers() async {
    final response = await _dio.get('$baseUrl/users');
    return response;
  }

  Future<Response> getFacultyStudyInfo(int facultyId) async {
    final response = await _dio.get('$baseUrl/faculty_study_info/$facultyId');
    return response;
  }

  Future<Response> getAllFacultyStudyInfo() async {
    final response = await _dio.get('$baseUrl/get_all_faculty_study_info');
    return response;
  }

  Future<void> addCourse(
      int facultyStudyInfoId, Map<String, dynamic> courseData) async {
    await _dio.post('$baseUrl/add_course/$facultyStudyInfoId',
        data: courseData);
  }

  Future<Response> updateCourse(int id, Map<String, dynamic> courseData) async {
    final response =
        await _dio.put('$baseUrl/update_course/$id', data: courseData);
    return response;
  }

  Future<Response> deleteCourse(int id) async {
    final response = await _dio.delete('$baseUrl/delete_course/$id');
    return response;
  }

  Future<Response> getCourses() async {
    final response = await _dio.get('$baseUrl/get_courses');
    return response;
  }

  Future<Response> getCoursesByFaculty(int facultyStudyInfoId) async {
    final response = await _dio.get('$baseUrl/courses/$facultyStudyInfoId');
    return response;
  }

  Future<List<dynamic>> getAllFacultyStudyInfoCourses(int facultyId) async {
    final response = await _dio
        .get('$baseUrl/get_all_faculty_study_info_courses/$facultyId');
    return response.data;
  }

  Future<void> addFacultyStudyInfoCourse(
      int facultyId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '$baseUrl/add_faculty_study_info_course/$facultyId',
        data: data,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to add faculty study info and course');
    }
  }

  Future<void> updateFacultyStudyInfoCourse(
      int id, Map<String, dynamic> data) async {
    final response = await _dio.put(
      '$baseUrl/update_faculty_study_info_course/$id',
      data: data,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update faculty study info and course');
    }
  }

  Future<void> deleteFacultyStudyInfoCourse(int id) async {
    final response = await _dio.delete(
      '$baseUrl/delete_faculty_study_info_course/$id',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete faculty study info and course');
    }
  }

  Future<Response> addPreparationTime(
      int courseId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '$baseUrl/add_preparation_time/$courseId',
        data: data,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to add preparation time: $error');
    }
  }

  Future<bool> checkPreparationTime(int courseId) async {
    try {
      final response =
          await _dio.get('$baseUrl/get_preparation_time/$courseId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getStudentStudyInfo(int studentId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/student_study_info/$studentId',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get student study info');
      }
    } catch (e) {
      throw Exception('Failed to get student study info: $e');
    }
  }

  Future<void> editPreparationTime(
      int preparationTimeId, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
          '$baseUrl/edit_preparation_time/$preparationTimeId',
          data: data);
      if (response.statusCode == 200) {
        print('Preparation time updated successfully');
      } else {
        throw Exception('Failed to update preparation time');
      }
    } catch (e) {
      throw Exception('Failed to update preparation time: $e');
    }
  }

  Future<Map<String, dynamic>> getPreparationTime(int preparationTimeId) async {
    final response =
        await _dio.get('$baseUrl/get_preparation_time/$preparationTimeId');
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getAttendanceRecords(
      int preparationTimesId) async {
    final response =
        await _dio.get('$baseUrl/get_attendance_records/$preparationTimesId');

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> records =
          List<Map<String, dynamic>>.from(response.data['attendance_records']);
      return records;
    } else {
      throw Exception('Failed to load attendance records');
    }
  }

  Future<void> createStudentAttendance(int attendanceRecordId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/create_student_attendance',
        data: {'attendance_record_id': attendanceRecordId},
      );
      if (response.statusCode == 200) {
        print('Student attendance records created successfully');
      } else {
        throw Exception('Failed to create student attendance records');
      }
    } catch (e) {
      throw Exception('Failed to create student attendance records: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentAttendance(
      int attendanceRecordId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/student_attendance/$attendanceRecordId',
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            response.data['student_attendance']);
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch student attendance records');
      }
    } catch (e) {
      throw Exception('Failed to fetch student attendance records: $e');
    }
  }

  Future<Map<String, dynamic>> getFacultyProfile(int facultyId) async {
    final String url = '$baseUrl/faculty/$facultyId';

    try {
      final Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data['faculty'];
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<Map<String, dynamic>> getStudentProfile(int studentId) async {
    final String url = '$baseUrl/student/$studentId';

    try {
      final Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data['student'];
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStudentProfile(int studentId) async {
    final response = await _dio.get('$baseUrl/student/$studentId');
    return response.data['student'];
  }

  Future<Map<String, dynamic>> fetchFacultyProfile(int facultyId) async {
    final response = await _dio.get('$baseUrl/faculty/$facultyId');
    return response.data['faculty'];
  }

  Future<String> uploadProfileImage(File image, int facultyId) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: fileName),
      'faculty_id': facultyId,
    });

    final response = await _dio.post(
      '$baseUrl/upload_profile_image',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return response.data['file_path'];
  }

  Future<String> uploadProfileImageStudent(File image, int studentId) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: fileName),
      'student_id': studentId,
    });

    final response = await _dio.post(
      '$baseUrl/upload_profile_image_student',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return response.data['file_path'];
  }

  Future<void> updateStudentName(int studentId, String newName) async {
    final response = await _dio.put(
      '$baseUrl/student/$studentId/update_name',
      data: {'new_name': newName},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update name');
    }
  }

  Future<void> updateStudentUnNumber(int studentId, String newUnNumber) async {
    final response = await _dio.put(
      '$baseUrl/student/$studentId/update_un_number',
      data: {'new_un_number': newUnNumber},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update phone number');
    }
  }

  Future<void> updateStudentEmail(int studentId, String newEmail) async {
    final response = await _dio.put(
      '$baseUrl/student/$studentId/update_email',
      data: {'new_email': newEmail},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update email');
    }
  }

  Future<void> updateStudentPassword(int studentId, String newPassword) async {
    final response = await _dio.put(
      '$baseUrl/student/$studentId/update_password',
      data: {'new_password': newPassword},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update password');
    }
  }

  Future<void> updateFacultyName(int facultyId, String newName) async {
    final response = await _dio.put(
      '$baseUrl/faculty/$facultyId/update_name',
      data: {'new_name': newName},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update name');
    }
  }

  Future<void> updateFacultyPhoneNumber(
      int facultyId, String newPhoneNumber) async {
    final response = await _dio.put(
      '$baseUrl/faculty/$facultyId/update_phone_number',
      data: {'new_phone_number': newPhoneNumber},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update phone number');
    }
  }

  Future<void> updateFacultyEmail(int facultyId, String newEmail) async {
    final response = await _dio.put(
      '$baseUrl/faculty/$facultyId/update_email',
      data: {'new_email': newEmail},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update email');
    }
  }

  Future<void> updateFacultyPassword(int facultyId, String newPassword) async {
    final response = await _dio.put(
      '$baseUrl/faculty/$facultyId/update_password',
      data: {'new_password': newPassword},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update password');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceRecords(
      int faculty_id) async {
    try {
      final response =
          await _dio.get('$baseUrl/attendance_records_data/$faculty_id');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            response.data['attendance_records_data']);
      } else {
        throw Exception('Failed to load attendance records');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFingerprintPreparation(
      int faculty_id) async {
    try {
      final response =
          await _dio.get('$baseUrl/fingerprint_preparation_data/$faculty_id');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            response.data['fingerprint_preparation_data']);
      } else {
        throw Exception('Failed to load Fingerprint Preparation');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentAttendanceData(
      int studentId) async {
    try {
      final response =
          await _dio.get('$baseUrl/get_student_attendance_data/$studentId');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            response.data['get_student_attendance_data']);
      } else {
        throw Exception('Failed to load Fingerprint Preparation');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
