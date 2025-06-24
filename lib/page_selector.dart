import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/Cubits/auth_cubit.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/0_Auth/UI/auth.dart';
import 'package:saibya_daily/Modules/Module_1_Base/UI/base.dart';

class PageSelector extends StatefulWidget {
  const PageSelector({super.key});

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().initAuthState(); // Initialize login state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is LoggedIn) {
            return const Base();
          } else if (state is LoggedOut) {
            return const Auth();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
