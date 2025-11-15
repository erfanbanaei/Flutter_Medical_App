import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medicalapp/src/core/%20theme/app_colors.dart';
import 'package:medicalapp/src/core/constants/app_routes.dart';
import 'package:medicalapp/src/presentation/widgets/doctor_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String selectedCategory = "Heart";
  int currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> categories = ["Heart", "Pil", "Dentist", "Pregnant"];

  final List<Map<String, dynamic>> doctors = [
    {
      "color": const Color(0xFFFFF2E4),
      "colorShadow": const Color(0xFFFFA340),
      "doctorName": "Dr. Jenny Wilson",
      "doctorPosition": "Dental Surgeon",
      "imageName": "Doctor1",
      "rateNumber": "4.8",
      "biography":
          "Dr. Jenny Wilson (Implantologist), is a Dentist in America, she has 20 years of...",
      "Calendar": 17,
      "time": "9:00",
      "isNight": false,
    },
    {
      "color": const Color(0xFFD0F8EC),
      "colorShadow": const Color(0xFF3CFFC4),
      "doctorName": "Dr. Kristin Watson",
      "doctorPosition": "Dental Surgeon",
      "imageName": "Doctor2",
      "rateNumber": "4.5",
      "biography":
          "Dr. Kristin Watson (Implantologist), is a Dentist in America, she has 20 years of...",
      "Calendar": 18,
      "time": "12:00",
      "isNight": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String category) {
    if (selectedCategory != category) {
      setState(() => selectedCategory = category);
    }
  }

  void _onNavItemTap(int index) {
    if (currentIndex != index) {
      setState(() => currentIndex = index);
    }
  }

  void _navigateToDetail(Map<String, dynamic> doctor) {
    Get.toNamed(
      AppRoutes.detailDoctor,
      arguments: {
        ...doctor,
        "colorShadow": (doctor["colorShadow"] as Color).withValues(alpha: 0.74),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                spacing: 32,
                children: [_buildCategoriesSection(), _buildDoctorsSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    const navItems = [
      {"icon": "Home.svg", "label": "home"},
      {"icon": "Calendar.svg", "label": "calendar"},
      {"icon": "Chat.svg", "label": "chat"},
      {"icon": "Profile.svg", "label": "profile"},
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onNavItemTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 12,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textMainColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: navItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: AnimatedScale(
              scale: currentIndex == index ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: SvgPicture.asset(
                "assets/icons/${item['icon']}",
                height: 28,
                colorFilter: ColorFilter.mode(
                  currentIndex == index
                      ? AppColors.primaryColor
                      : AppColors.textMainColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          label: item['label']!,
        );
      }).toList(),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AppColors.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTopBar(), _buildHeaderTitle(), _buildSearchBar()],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Hi, Steven",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFFC4E1FF).withValues(alpha: 0.15),
          ),
          child: Center(
            child: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/Notification.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                Positioned(
                  right: 4,
                  top: 2,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.redColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return const Row(
      children: [
        Text(
          "Let's find\nyour top doctor!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 56,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(
            color: AppColors.textMainColor,
            fontWeight: FontWeight.w100,
            letterSpacing: 1.5,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 5,
              bottom: 5,
              right: 5,
            ),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              colorFilter: ColorFilter.mode(
                AppColors.textMainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(64),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(64),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(64),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: categories
                  .map((category) => _buildCategoryItem(category))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name) {
    final isSelected = selectedCategory == name;

    return GestureDetector(
      onTap: () => _onCategoryTap(name),
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
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : AppColors.shadowColor.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: isSelected ? 15 : 25,
            ),
          ],
        ),
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Image.asset("assets/icons/$name.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsSection() {
    return Column(
      spacing: 24,
      children: doctors.asMap().entries.map((entry) {
        final index = entry.key;
        final doctor = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 200)),
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
          child: doctorsWidgets(
            color: doctor["color"],
            colorShadow: doctor["colorShadow"],
            doctorName: doctor["doctorName"],
            doctorPosition: doctor["doctorPosition"],
            imageName: doctor["imageName"],
            rateNumber: doctor["rateNumber"],
            context: context,
            ontap: () => _navigateToDetail(doctor),
          ),
        );
      }).toList(),
    );
  }
}
