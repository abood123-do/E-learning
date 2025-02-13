import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/pages/home_teacher/cubits/create_course_cubit/create_course_cubit.dart';

class AddCoursePage extends StatefulWidget {
  AddCoursePage({
    super.key,
  });
  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  @override
  Widget build(BuildContext context) {
    final createCourseCubit = context.read<CreateCourseCubit>();
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Course"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: createCourseCubit.formKey,
          child: ListView(
            children: [
              buildInputField("Course Name", "Enter course name",
                  createCourseCubit.courseNameController),
              buildInputField("Course Details", "Enter course details",
                  createCourseCubit.courseDetailsController),
              buildInputField("Course Hours", "Enter course hours",
                  createCourseCubit.courseHoursController,
                  keyboardType: TextInputType.number),
              buildInputField("Total Lessons", "Enter total lessons",
                  createCourseCubit.totalLessonsController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await createCourseCubit.pickImage(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Add Course Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<CreateCourseCubit, CreateCourseState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return createCourseCubit.courseImage == null
                      ? const SizedBox()
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image: FileImage(
                                File(createCourseCubit.courseImage!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<CreateCourseCubit, CreateCourseState>(
                listener: (context, state) {
                  if (state is CreateCourseLoadingState) {
                    loadingDialog(
                        context: context,
                        mediaQuery: mediaQuery,
                        title: 'Loading...');
                  } else if (state is CreateCourseFailedState) {
                    Navigator.pop(context);
                    errorDialog(context: context, text: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (createCourseCubit.formKey.currentState!.validate()) {
                        await createCourseCubit.createCourse(context: context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Confirm Addition",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800])),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'this field is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: const OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 2)),
            ),
          ),
        ],
      ),
    );
  }
}
