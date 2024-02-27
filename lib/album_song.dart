import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_player/fullscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query_platform_interface/src/models/album_model.dart';

import 'myclass.dart';

class album_song extends StatefulWidget {
  AlbumModel l;
  album_song(this.l);


  @override
  State<album_song> createState() => _album_songState();
}

class _album_songState extends State<album_song> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: m.getbyalbum(widget.l.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> l = snapshot.data as List<SongModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    for(int i =0; i<m.song.length; i++){
                      if(m.song.value[i].id == l[index].id){
                        if(i == m.cur_index.value){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return fullscreen();
                          },));
                        }
                        else
                          {
                            m.cur_index.value = i;
                            myclass.player.play(DeviceFileSource(m.song[m.cur_index.value].data));
                          }
                      }
                    }
                  },
                  title: Text("${l[index].title}"),

                );

              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
