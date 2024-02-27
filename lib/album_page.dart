import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/album_song.dart';
import 'package:music_player/myclass.dart';
import 'package:on_audio_query/on_audio_query.dart';

class album_page extends StatefulWidget {
  const album_page({super.key});

  @override
  State<album_page> createState() => _album_pageState();
}

class _album_pageState extends State<album_page> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: m.album_get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<AlbumModel> l = snapshot.data as List<AlbumModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return album_song(l[index]);
                    },));
                  },
                  title: Text("${l[index].album}"),
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
