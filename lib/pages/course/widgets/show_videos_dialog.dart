import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/course_detail.dart';
import 'package:login/pages/course/cubits/sessions_cuibt/sessions_cubit.dart';
import 'package:login/pages/course/cubits/video_cubit/video_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

void showVideos(BuildContext context, List<Session> allSessions) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => SessionsCubit(),
        child: BlocConsumer<SessionsCubit, SessionsState>(
          listener: (context, state) {
            if (state is SessionsFailedState) {
              errorDialog(context: context, text: state.errorMessage);
            }
          },
          builder: (context, state) {
            final mediaQuery = MediaQuery.of(context).size;
            return AlertDialog(
              title: Text("Videos"),
              content: SizedBox(
                width: double.maxFinite,
                child: allSessions.isEmpty
                    ? const Text('There is no sessions for this course')
                    : ListView.builder(
                        itemCount: state is SessionsLoadingState
                            ? 5
                            : allSessions.length,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: state is SessionsLoadingState,
                            child: state is SessionsLoadingState
                                ? ListTile(
                                    leading:
                                        const Icon(Icons.play_circle_outline),
                                    title: SizedBox(
                                        width: mediaQuery.width / 1.3,
                                        child: const Text(
                                            'This is a random text just for skeletonizer')),
                                  )
                                : ListTile(
                                    leading:
                                        const Icon(Icons.play_circle_outline),
                                    title: SizedBox(
                                        width: mediaQuery.width / 1.3,
                                        child: Text(
                                            allSessions[index].sessionTitle)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => VideoCubit()
                                              ..initState(
                                                  videoUrl:
                                                      allSessions[index].video),
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
