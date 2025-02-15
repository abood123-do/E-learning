import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../server/image_server.dart';
part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;

  Future<void> initState({required String videoUrl}) async {
    emit(VideoLoadingState());
    print('hello we are here');

    // Use a valid video URL
    // String url =
    //     'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4';

    String url = '${ImageUrl.imageUrl}/$videoUrl';

    // Initialize the video player controller
    _videoPlayerController = VideoPlayerController.network(url);

    try {
      // Wait for the video to initialize
      await _videoPlayerController!.initialize();

      // Initialize the Chewie controller
      chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
        ),
      );

      emit(VideoInitial());
    } catch (e) {
      // Handle initialization errors
      print('Error initializing video: $e');
      emit(VideoInitial());
    }
  }
}
