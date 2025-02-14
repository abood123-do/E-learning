import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/course/cubits/script_cubit/script_cubit.dart';

class ScriptScreen extends StatelessWidget {
  const ScriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scriptCubit = context.read<ScriptCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Script'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              maxLines: 10,
              controller: scriptCubit.scriptController,
              decoration: InputDecoration(
                hintText: 'Enter your script',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            BlocConsumer<ScriptCubit, ScriptState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state is ScriptLoadingState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        width: 900.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5, // Add shadow
                          ),
                          onPressed: () {
                            scriptCubit.generateQuiz(context);
                          },
                          child: const Text(
                            "Generate Quiz",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
