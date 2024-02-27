import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/artist_song.dart';
import 'package:music_player/myclass.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artist_page extends StatefulWidget {
  const artist_page({super.key});

  @override
  State<artist_page> createState() => _artist_pageState();
}

class _artist_pageState extends State<artist_page> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: m.artist_get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<ArtistModel> l = snapshot.data as List<ArtistModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return artist_song(l[index]);
                    },));
                  },
                  child: ListTile(
                    title: Text("${l[index].artist}"),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
