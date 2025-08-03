import 'package:flutter/material.dart';
import 'package:musicland/components/neu_box.dart';
import 'package:musicland/model/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart'; // Import the marquee package

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formateTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, "0");
    String formatedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formatedTime;
  }

  bool _isTextOverflowing(
    String text,
    TextStyle style,
    double maxWidth, {
    int maxLines = 1,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;

        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        final songNameStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        );
        final artistNameStyle = TextStyle(
          fontSize: 16, // Adjust font size as needed
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: Text("PLAYLIST")),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 350,
                            height: 350,
                            child: (currentSong.albumArt != null)
                                ? Image.memory(
                                    currentSong.albumArt!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/app_icon.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Song Name
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final bool songNameOverflows =
                                            _isTextOverflowing(
                                              currentSong.songName,
                                              songNameStyle,
                                              constraints.maxWidth,
                                            );

                                        if (songNameOverflows) {
                                          return SizedBox(
                                            height: songNameStyle.fontSize! + 5,
                                            child: Marquee(
                                              text: currentSong.songName,
                                              style: songNameStyle,
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              blankSpace: 20.0,
                                              velocity: 50.0,
                                              pauseAfterRound: const Duration(
                                                seconds: 1,
                                              ),
                                              startPadding: 0.0,
                                              accelerationDuration:
                                                  const Duration(seconds: 1),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration:
                                                  const Duration(
                                                    milliseconds: 500,
                                                  ),
                                              decelerationCurve: Curves.easeOut,
                                              fadingEdgeStartFraction: 0.1,
                                              fadingEdgeEndFraction: 0.1,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            currentSong.songName,
                                            style: songNameStyle,
                                            overflow: TextOverflow
                                                .ellipsis, // Fallback ellipsis
                                          );
                                        }
                                      },
                                    ),
                                    // Artist Name
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final bool artistNameOverflows =
                                            _isTextOverflowing(
                                              currentSong.artistName,
                                              artistNameStyle,
                                              constraints.maxWidth,
                                            );

                                        if (artistNameOverflows) {
                                          return SizedBox(
                                            height:
                                                artistNameStyle.fontSize! + 5,
                                            child: Marquee(
                                              text: currentSong.artistName,
                                              style: artistNameStyle,
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              blankSpace: 20.0,
                                              velocity: 30.0,
                                              pauseAfterRound: const Duration(
                                                seconds: 1,
                                              ),
                                              startPadding: 0.0,
                                              accelerationDuration:
                                                  const Duration(seconds: 1),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration:
                                                  const Duration(
                                                    milliseconds: 500,
                                                  ),
                                              decelerationCurve: Curves.easeOut,
                                              fadingEdgeStartFraction: 0.1,
                                              fadingEdgeEndFraction: 0.1,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            currentSong.artistName,
                                            style: artistNameStyle,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Song duration
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formateTime(value.currentDuration)),
                            Text(formateTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 3,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          inactiveColor: Theme.of(
                            context,
                          ).colorScheme.inversePrimary,
                          onChanged: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  // buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: NeuBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: NeuBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
