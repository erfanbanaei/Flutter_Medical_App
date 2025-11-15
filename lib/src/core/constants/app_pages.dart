import 'package:get/get.dart';
import 'package:medicalapp/src/presentation/pages/detailt_doctor_page.dart';
import 'package:medicalapp/src/presentation/pages/home_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.detailDoctor, page: () => const DetailtDoctorPage()),
  ];
}