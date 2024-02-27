import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/fullscreen.dart';
import 'package:music_player/myclass.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';

class fav_song extends StatefulWidget {
  const fav_song({super.key});

  @override
  State<fav_song> createState() => _fav_songState();
}

class _fav_songState extends State<fav_song> {
  myclass m = Get.put(myclass());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
                data: SliderTheme.of(context as BuildContext)
                    .copyWith(activeTickMarkColor: Colors.grey),
                child: Obx(() => Slider(
                  min: 0,
                  max: m.song[m.cur_index.value].duration!.toDouble(),
                  value: m.duration.value,
                  onChanged: (value) {},
                ))),
            ListTile(
              title: Obx(() => m.song.isNotEmpty
                  ? Obx(() => Text(m.song[m.cur_index.value].title))
                  : Text("")),
              trailing: InkWell(
                onTap: () {
                  if (m.temp == true) {
                    m.temp.value = false;
                    myclass.player.pause();
                  } else {
                    myclass.player.play(DeviceFileSource(
                        m.song.value[m.cur_index.value].data));
                    m.temp.value = true;
                  }
                },
                child: Obx(() => m.temp.value
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow)),
              ),
            )
          ],
        ),
      body: FutureBuilder(future: m.get_fav(), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          List<FavoritesEntity> l = snapshot.data as List<FavoritesEntity>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for(int i=0; i<m.song.length; i++){
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
                  child: ListTile(
                    title: Text("${l[index].title}"),
                  ),
                );
            },);
        }
        else{
          return CircularProgressIndicator();
        }
      },),
    );
  }
}
