import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/myclass.dart';
import 'package:on_audio_room/on_audio_room.dart';

class fullscreen extends StatefulWidget {
  const fullscreen({super.key});

  @override
  State<fullscreen> createState() => _fullscreenState();
}

class _fullscreenState extends State<fullscreen> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    m.check_fav();
    m.getDuration();
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 210,
                  width: 210,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(105),
                      border: Border.all(width: 4, color: Colors.black)),
                  child: Icon(
                    Icons.music_note_sharp,
                    size: 120,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    m.cur_index.value--;
                    myclass.player.play(
                        DeviceFileSource(m.song.value[m.cur_index.value].data));
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(
                      Icons.skip_previous,
                      size: 40,
                    ),
                  ),
                ),
                InkWell(
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
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Obx(() => m.temp.value
                        ? Icon(
                            Icons.pause,
                            size: 40,
                          )
                        : Icon(
                            Icons.play_arrow,
                            size: 50,
                          )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    m.cur_index.value++;
                    myclass.player.play(
                        DeviceFileSource(m.song.value[m.cur_index.value].data));
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(
                      Icons.skip_next,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Obx(() => m.is_fav.value
                    ? IconButton(onPressed: () async {
                  bool deleteFromResult = await OnAudioRoom().deleteFrom(
                    RoomType.FAVORITES,
                    m.song.value[m.cur_index.value].id,
                    //playlistKey,
                  );
                  m.check_fav();

                }, icon: Icon(Icons.favorite))
                    : IconButton(
                        onPressed: () async {
                          int? addToResult = await OnAudioRoom().addTo(
                            RoomType.FAVORITES,
                            m.song.value[m.cur_index.value].getMap.toFavoritesEntity(),
                          );
                          m.check_fav();
                        }, icon: Icon(Icons.favorite_border)))
              ],
            )
          ],
        ),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
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
            title: Obx(() => Text(m.song.value[m.cur_index.value].title)),
          )
        ]));
  }
}
