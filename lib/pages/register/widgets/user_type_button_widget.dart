import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/colors.dart';
import '../cubit/register_cubit.dart';

class UserTypeButtonWidget extends StatelessWidget {
  const UserTypeButtonWidget(
      {super.key, required this.label, required this.value});

  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            Radio(
              value: value,
              groupValue: registerCubit.userType,
              activeColor: AppColors.primaryElement,
              onChanged: (newValue) {
                registerCubit.changeUserType(newValue!);
              },
            ),
            Text(label, style: TextStyle(fontSize: 16.sp)),
          ],
        );
      },
    );
  }
}
