import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/fullscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'myclass.dart';

class song_page extends StatefulWidget {
  const song_page({super.key});

  @override
  State<song_page> createState() => _song_pageState();
}

class _song_pageState extends State<song_page> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: m.get_song(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<SongModel> l = snapshot.data as List<SongModel>;
              return ListView.builder(
                itemCount: l.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if(index == m.cur_index.value){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return fullscreen();
                        },));
                      }
                      else
                        {
                          m.cur_index.value = index;
                          myclass.player.play(DeviceFileSource(m.song[m.cur_index.value].data));
                        }
                    },
                    child: ListTile(
                      title: Text("${l[index].title}"),
                    ),
                  );
                },
              );
            }
            else{
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
