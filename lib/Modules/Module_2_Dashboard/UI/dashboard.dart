import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/Cubits/auth_cubit.dart';
import 'package:saibya_daily/Modules/Module_5_Stats/UI/stats.dart';
import 'package:saibya_daily/Modules/Module_4_HealthTip/UI/health_tip.dart';
import 'package:saibya_daily/Modules/Module_5_Stats/UI/stats_chart.dart';
import 'package:saibya_daily/Services/local_storage_service.dart';
import 'package:saibya_daily/Models/user_model.dart';
import 'package:saibya_daily/Utils/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final UserModel user = LocalStorageService.instance.userData;
    setState(() {
      userName = user.name ?? 'Guest'; // Fallback to 'Guest' if name is null
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Hello
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: "$userName!",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // menu icon - logout

                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          context.read<AuthCubit>().logOut();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert), // Three dot icon
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.onPrimary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // health Tip
              HealthTip(),

              WellnessTrendsChart(),

              const SizedBox(height: 16),

              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.onPrimary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Chart
              Stats(),
              const SizedBox(height: 16),

              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.onPrimary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
