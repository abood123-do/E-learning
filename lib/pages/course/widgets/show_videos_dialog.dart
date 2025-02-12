import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/pages/course/course_detail.dart';
import 'package:login/pages/course/cubits/sessions_cuibt/sessions_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

void showVideos(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => SessionsCubit()..getAllSessions(context: context),
        child: BlocConsumer<SessionsCubit, SessionsState>(
          listener: (context, state) {
            if (state is SessionsFailedState) {
              errorDialog(context: context, text: state.errorMessage);
            }
          },
          builder: (context, state) {
            final sessionCubit = context.read<SessionsCubit>();
            final mediaQuery = MediaQuery.of(context).size;
            return AlertDialog(
              title: Text("Videos"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: state is SessionsLoadingState
                      ? 5
                      : sessionCubit.allSessions.length,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: state is SessionsLoadingState,
                      child: ListTile(
                        leading: Icon(Icons.play_circle_outline),
                        title: SizedBox(
                            width: mediaQuery.width / 1.3,
                            child: Text(
                                sessionCubit.allSessions[index].sessionTitle)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPage(
                                  session: sessionCubit.allSessions[index]),
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
