import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/fullscreen.dart';
import 'package:music_player/myclass.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artist_song extends StatefulWidget {
  ArtistModel l;
  artist_song(this.l);


  @override
  State<artist_song> createState() => _artist_songState();
}

class _artist_songState extends State<artist_song> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
              data: SliderTheme.of(context)
                  .copyWith(activeTickMarkColor: Colors.grey),
              child: Obx(() => Slider(
                min: 0,
                max: m.song.length > 0
                    ? m.song[m.cur_index.value].duration!.toDouble()
                    : 0,
                value: m.duration.value,
                onChanged: (value) {},
              ))),
          ListTile(
            title: Obx(() => m.song.isNotEmpty?Obx(() => Text(m.song[m.cur_index.value].title)):Text("")),
            trailing: InkWell(
              onTap: () {
                if(m.temp == true){
                  myclass.player.pause();
                  m.temp.value = false;
                }
                else{
                  myclass.player.play(DeviceFileSource(m.song.value[m.cur_index.value].data));
                  m.temp.value = true;
                }
              },
              child: Obx(() => m.temp.value ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: m.getbyartist(widget.l.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> l = snapshot.data as List<SongModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    for(int i = 0; i<m.song.length; i++){

                      if(m.song.value[i].id==l[index].id){
                         if(i==m.cur_index.value)
                           {

                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return fullscreen();
                              },));

                           }
                         else
                           {
                                m.cur_index.value=i;
                                myclass.player.play(DeviceFileSource(m.song[m.cur_index.value].data));
                           }

                      }
                    }
                  },
                  title: Text("${l[index].title}"),
                  subtitle: Text("${l[index].artist}"),
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
