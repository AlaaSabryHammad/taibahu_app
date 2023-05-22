import 'package:taibahu_app/admin_screens/admin_add_patient.dart';
import 'package:taibahu_app/admin_screens/admin_add_pharmacian.dart';
import 'package:taibahu_app/admin_screens/admin_view_patients.dart';
import 'package:taibahu_app/admin_screens/admin_view_pharmacists.dart';
import 'package:taibahu_app/admin_screens/admin_view_user_evaluations.dart';
import 'package:taibahu_app/admin_screens/success/admin_add_doctor_success.dart';
import 'package:taibahu_app/admin_screens/success/admin_add_patient_success.dart';
import 'package:taibahu_app/admin_screens/success/admin_update_patient_success.dart';
import 'package:taibahu_app/doctor_screens/success/doctor_add_pre_success.dart';
import 'package:taibahu_app/patient_screens/booking_appointment/patient_select_clinic.dart';
import 'package:taibahu_app/patient_screens/patient_add_service_evaluation.dart';
import 'package:taibahu_app/patient_screens/patient_home_chat_screen.dart';
import 'package:taibahu_app/patient_screens/patient_view_service_evaluations.dart';
import 'package:taibahu_app/admin_screens/admin_add_doctor_screen.dart';
import 'package:taibahu_app/patient_screens/success/patient_add_evaluation_success.dart';
import 'package:taibahu_app/patient_screens/success/patient_book_app_success.dart';
import 'package:taibahu_app/patient_screens/success/patient_register_success.dart';
import 'package:taibahu_app/pharmacist_screens/pharmacist_login.dart';
import 'package:taibahu_app/screens/choose_login_screen.dart';
import 'package:taibahu_app/doctor_screens/doctor_appointments.dart';
import 'package:taibahu_app/doctor_screens/doctor_home_screen.dart';
import 'package:taibahu_app/admin_screens/home_screen.dart';
import 'package:taibahu_app/patient_screens/patient_home_screen.dart';
import 'package:taibahu_app/admin_screens/admin_login.dart';
import 'package:taibahu_app/doctor_screens/doctor_login_screen.dart';
import 'package:taibahu_app/screens/splash_screen/splash_screen.dart';
import 'package:taibahu_app/screens/user_appointments/user_appointments.dart';
import 'package:taibahu_app/admin_screens/admin_view_doctors_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'admin_screens/admin_add_clinic_screen.dart';
import 'patient_screens/book_patient_appointments.dart';
import 'patient_screens/patient_login_screen.dart';
import 'patient_screens/patient_register_screen.dart';
import 'patient_screens/patient_view_prescription.dart';
import 'patient_screens/view_pateint_appointments_screen.dart';

Future onGetMessage(RemoteMessage message) async {
  print(message.notification!.body);
  // Navigator.pushNamed(context, routeName)
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onGetMessage);
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/choose-login': (context) => const ChooseLoginScreen(),
        '/patient-login': (context) => const PatientLoginScreen(),
        '/patient-register': (context) => const PatientRegisterScreen(),
        '/patient-add-evaluation': (context) =>
            const PatientAddServiceEvaluations(),
        '/patient-view-evaluations': (context) =>
            const PatientViewServiceEvaluations(),
        '/patient-home-chat': (context) => const PatientHomeChatScreen(),
        '/patient-view-prescription': (context) =>
            const PatientViewDescriptions(),
        '/patient-register-success': (context) =>
            const PatientRegisterSuccess(),
        '/patient-home': (context) => const PatientHomeScreen(),
        '/patient-add-evaluation-success': (context) =>
            const PatientAddEvaluationSuccess(),
        '/book-patient-app': (context) => const BookPatientAppointments(),
        '/patient-book-app-success': (context) => const PatientBookAppSuccess(),
        '/patient-select-clinic': (context) => const PatientSelectClinic(),
        '/view-patient-app': (context) => const ViewPatientAppointments(),
        '/home': (context) => const HomeScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin-add-patient': (context) => const AdminAddPatient(),
        '/admin-update-patient-success': (context) =>
            const AdminUpdatePatientSuccess(),
        '/admin-view-patients': (context) => const AdminViewPatients(),
        '/admin-view-evaluations': (context) =>
            const AdminViewUserEvaluations(),
        '/admin-add-doctor-success': (context) => const AdminAddDoctorSuccess(),
        '/admin-add-patient-success': (context) =>
            const AdminAddPatientSuccess(),
        '/admin-add-pharmacian': (context) => const AdminAddPharmacian(),
        '/admin-view-pharmacists': (context) => const AdminViewPharmacists(),
        '/user-appointments': (context) => const UserAppointmentsScreen(),
        '/add-doctor': (context) => const AddDoctorScreen(),
        '/view-doctors': (context) => const ViewDoctorsScreen(),
        '/add-clinic': (context) => const AddClinicScreen(),
        '/doctor-login': (context) => const DoctorLoginScreen(),
        '/doctor-home': (context) => const DoctorHomeScreen(),
        '/doctor-app': (context) => const DoctorAppointments(),
        '/doctor-add-pre-success': (context) => const DoctorAddPreSuccess(),
        '/pharmacian-login': (context) => const PharmacistLogin(),
      },
    );
  }
}
