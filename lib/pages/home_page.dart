import "package:flutter/material.dart";
import "package:musicland/components/my_drawer.dart";
import "package:musicland/model/playlist_provider.dart";
import "package:musicland/model/song.dart";
import "package:musicland/pages/song_page.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).fetchSongsFromDevice();
  }

  void goToSong(int songIndex) {
    Provider.of<PlaylistProvider>(context, listen: false).currentSongIndex =
        songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage()),
    );
  }

  // New method to navigate to the current song page
  void goToCurrentSongPage(BuildContext context) {
    // Only navigate if a song is currently selected/playing
    final playlistProvider = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    );
    if (playlistProvider.currentSongIndex != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SongPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Suresh")),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          if (playlist.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            // Use Column to stack the list and the player bar
            children: [
              Expanded(
                // This makes the ListView take up remaining space
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final Song song = playlist[index];

                    return ListTile(
                      title: Text(song.songName),
                      subtitle: Text(song.artistName),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: (song.albumArt != null)
                              ? Image.memory(song.albumArt!, fit: BoxFit.cover)
                              : Image.asset(
                                  "assets/app_icon.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      onTap: () => goToSong(index),
                    );
                  },
                ),
              ),

              if (value.currentSongIndex != null && playlist.isNotEmpty)
                GestureDetector(
                  onTap: () => goToCurrentSongPage(context),
                  child: Container(
                    height: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer, // Or a custom color
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                (playlist[value.currentSongIndex!].albumArt !=
                                    null)
                                ? Image.memory(
                                    playlist[value.currentSongIndex!].albumArt!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/app_icon.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist[value.currentSongIndex!].songName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                playlist[value.currentSongIndex!].artistName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          onPressed: value.pauseOrResume,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
