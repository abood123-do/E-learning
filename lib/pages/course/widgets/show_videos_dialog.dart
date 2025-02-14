import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/course_detail.dart';
import 'package:login/pages/course/cubits/course_details_cubit/course_details_cubit.dart';
import 'package:login/pages/course/cubits/session_comment_cubit/session_comment_cubit.dart';
import 'package:login/pages/course/cubits/session_dialog_cubit/session_dialog_cubit.dart';
import 'package:login/pages/course/cubits/video_cubit/video_cubit.dart';
import 'package:login/utils/check_role.dart';
import 'package:skeletonizer/skeletonizer.dart';

void showVideos(BuildContext context, List<Session> allSessions,
    CourseDetailsCubit courseDetailsCubit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => SessionDialogCubit(),
        child: BlocConsumer<SessionDialogCubit, SessionDialogState>(
          listener: (context, state) {
            if (state is SessionDialogFailedState) {
              Navigator.pop(context);
              errorDialog(context: context, text: state.errorMessage);
            } else if (state is SessionDialogLoadingState) {
              loadingDialog(
                  context: context,
                  mediaQuery: MediaQuery.of(context).size,
                  title: 'loading...');
            } else if (state is SessionDialogSuccessState) {
              courseDetailsCubit.refresh();
            }
          },
          builder: (context, state) {
            final mediaQuery = MediaQuery.of(context).size;
            final sessionDialogCubit = context.read<SessionDialogCubit>();
            return AlertDialog(
              title: const Text("Sessions"),
              content: SizedBox(
                width: double.maxFinite,
                child: allSessions.isEmpty
                    ? const Text('There is no sessions for this course')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: allSessions.length,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: false,
                            child: ListTile(
                              leading: const Icon(Icons.play_circle_outline),
                              title: SizedBox(
                                  width: mediaQuery.width / 1.3,
                                  child: Text(allSessions[index].sessionTitle)),
                              trailing: checkTeacherRole()
                                  ? PopupMenuButton<int>(
                                      onSelected: (value) {
                                        if (value == 1) {
                                          sessionDialogCubit.deleteSession(
                                              context: context,
                                              allSession: allSessions,
                                              currentSession:
                                                  allSessions[index]);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => VideoCubit()
                                            ..initState(
                                                videoUrl:
                                                    allSessions[index].video),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              SessionCommentCubit()
                                                ..getAllComment(
                                                    context: context),
                                        )
                                      ],
                                      child: VideoPage(
                                          session: allSessions[index]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
