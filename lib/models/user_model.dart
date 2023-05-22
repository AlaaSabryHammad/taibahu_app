class UserModel {
  final String name;
  final String label;
  final String date;
  final String time;

  UserModel(this.name, this.label, this.date, this.time);
}

List<UserModel> usersUpcoming = [
  UserModel('Sara Khaled', 'Family medicine', '14/5/2022', '10:00 AM'),
  UserModel('Manal Ahmed', 'Physical Therapy', '16/5/2022', '8:00 AM'),
  UserModel('Reem Saqr', 'Reys', '25/7/2022', '12:00 AM'),
  UserModel('Farah Osama', 'Social Specialist', '29/7/2022', '11:00 AM'),
  UserModel('Reem Khaled', 'Physical Therapy', '14/5/2022', '10:00 AM'),
  UserModel('Baraa Alaa', 'Reys', '14/5/2022', '10:00 AM'),
  UserModel('Doaa Ali', 'Family medicine', '14/5/2022', '10:00 AM'),
];

List<UserModel> usersCompleted = [
  UserModel('Sara Khaled', 'Family medicine', '14/5/2022', '10:00 AM'),
  UserModel('Manal Ahmed', 'Physical Therapy', '16/5/2022', '8:00 AM'),
  UserModel('Reem Saqr', 'Reys', '25/7/2022', '12:00 AM'),
  UserModel('Farah Osama', 'Social Specialist', '29/7/2022', '11:00 AM'),
  UserModel('Reem Khaled', 'Physical Therapy', '14/5/2022', '10:00 AM'),
  UserModel('Baraa Alaa', 'Reys', '14/5/2022', '10:00 AM'),
  UserModel('Doaa Ali', 'Family medicine', '14/5/2022', '10:00 AM'),
];

List<UserModel> usersCancelled = [
  UserModel('Sara Khaled', 'Family medicine', '14/5/2022', '10:00 AM'),
  UserModel('Farah Osama', 'Social Specialist', '29/7/2022', '11:00 AM'),
];