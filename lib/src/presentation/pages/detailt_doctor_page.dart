import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medicalapp/src/core/%20theme/app_colors.dart';
import 'package:medicalapp/src/presentation/widgets/doctor_widgets.dart';

class DetailtDoctorPage extends StatefulWidget {
  const DetailtDoctorPage({super.key});

  @override
  State<DetailtDoctorPage> createState() => _DetailtDoctorPageState();
}

class _DetailtDoctorPageState extends State<DetailtDoctorPage>
    with SingleTickerProviderStateMixin {
  late final Map<String, dynamic> args;
  String selectedCalendar = "";
  String selectedTime = "";
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late final List<Map<String, dynamic>> calendarDays;

  final List<Map<String, dynamic>> timeSlots = [
    {"time": "9:00", "isNight": true},
    {"time": "3:00", "isNight": false},
    {"time": "6:00", "isNight": false},
  ];

  // Specialities data
  final List<String> specialities = [
    "Dental Surgeon",
    "Aesthetic Surgeon",
    "General Dentist",
  ];

  @override
  void initState() {
    super.initState();
    args = Get.arguments as Map<String, dynamic>;

    final baseDate = args["Calendar"] as int;
    calendarDays = [
      {"date": baseDate, "day": "Sun"},
      {"date": baseDate + 1, "day": "Mon"},
      {"date": baseDate + 2, "day": "Tue"},
      {"date": baseDate + 3, "day": "Wed"},
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectCalendar(String date) {
    if (selectedCalendar != date) {
      setState(() => selectedCalendar = date);
    }
  }

  void _selectTime(String time) {
    if (selectedTime != time) {
      setState(() => selectedTime = time);
    }
  }

  void _bookAppointment() {
    if (selectedCalendar.isEmpty || selectedTime.isEmpty) {
      Get.snackbar(
        "Required",
        "Please select date and time",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }
    // Handle booking logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 8),
              _buildDoctorCard(),
              _buildSection(delay: 200, child: _buildBiographySection()),
              _buildSection(delay: 300, child: _buildSpecialitiesSection()),
              _buildSection(delay: 400, child: _buildCalendarSection()),
              _buildSection(delay: 500, child: _buildTimeSection()),
              const SizedBox(height: 32),
              _buildSection(delay: 600, child: _buildBookButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          const Text(
            "Detail Doctor",
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 0.15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF050618).withValues(alpha: 0.06),
                    offset: const Offset(0, 4),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: doctorsWidgets(
          color: args["color"],
          colorShadow: args["colorShadow"],
          imageName: args["imageName"],
          doctorName: args["doctorName"],
          doctorPosition: args["doctorPosition"],
          rateNumber: args["rateNumber"],
          ontap: () {},
          context: context,
        ),
      ),
    );
  }

  Widget _buildBiographySection() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Biography",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMainColor.withValues(alpha: 0.5),
            letterSpacing: 0.15,
            fontWeight: FontWeight.w500,
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textMainColor.withValues(alpha: 0.5),
              letterSpacing: 0.15,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(text: args["biography"]),
              TextSpan(
                text: " Read More ",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialitiesSection() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Specialities",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMainColor.withValues(alpha: 0.5),
            letterSpacing: 0.15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: specialities.asMap().entries.map((entry) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (entry.key * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textMainColor.withValues(alpha: 0.5),
                  letterSpacing: 0.15,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Calendar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textMainColor,
                letterSpacing: 0.15,
              ),
            ),
            Row(
              children: [
                Text(
                  "July",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textMainColor.withValues(alpha: 0.5),
                    letterSpacing: 0.2,
                  ),
                ),
                SvgPicture.asset(
                  "assets/icons/ArrowRight.svg",
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    AppColors.textMainColor.withValues(alpha: 0.5),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: calendarDays.asMap().entries.map((entry) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200 + (entry.key * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: _buildCalendarItem(
                entry.value["date"] as int,
                entry.value["day"] as String,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendarItem(int date, String day) {
    final isSelected = selectedCalendar == date.toString();

    return GestureDetector(
      onTap: () => _selectCalendar(date.toString()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.4)
                  : AppColors.shadowColor.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: isSelected ? 15 : 25,
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.textMainColor,
              ),
              child: Text("$date"),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
                letterSpacing: 0.15,
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.textMainColor.withValues(alpha: 0.5),
              ),
              child: Text(day),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Time",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.textMainColor,
            letterSpacing: 0.15,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: timeSlots.asMap().entries.map((entry) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (entry.key * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: _buildTimeItem(
                entry.value["time"] as String,
                entry.value["isNight"] as bool,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeItem(String time, bool isNight) {
    final isSelected = selectedTime == time;

    return GestureDetector(
      onTap: () => _selectTime(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(44),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.4)
                  : AppColors.shadowColor.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: isSelected ? 15 : 25,
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 0.15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.whiteColor : AppColors.textMainColor,
          ),
          child: Text("$time${isNight ? ' PM' : ' AM'}"),
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return GestureDetector(
      onTap: _bookAppointment,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, _) {
          return Transform.scale(
            scale: value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(46),
                color: AppColors.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                    offset: const Offset(0, 10),
                    blurRadius: 25,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
