import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/myclass.dart';
import 'package:music_player/song_page.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';
import 'album_page.dart';
import 'artist_page.dart';
import 'fav_page.dart';

Future<void> main() async {
  await OnAudioRoom().initRoom();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: First(),
  ));
}

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  myclass m = Get.put(myclass());

  late  int curindex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curindex=0;
     myclass.player.onPlayerComplete.listen((event) {
       next_song();
     });
    get();
  }

  get() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
      print(status);
    }
    print(status);
  }
  next_song()
  {
       if(curindex< m.song.length-1)
         {
            curindex++;
            myclass.player.play(DeviceFileSource(
                m.song.value[curindex].data));
            m.cur_index.value=curindex;

            m.temp.value = true;

         }
       else
         {
                myclass.player.stop();
                m.temp.value=false;
         }
  }

  @override
  Widget build(BuildContext context) {
    m.getDuration();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                child: Text("Song"),
              ),
              Tab(
                child: Text("Fav"),
              ),
              Tab(
                child: Text("Artist"),
              ),
              Tab(
                child: Text("Album"),
              ),
            ]),
          ),
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
          body: TabBarView(
            children: [
              song_page(),
              fav_page(),
              artist_page(),
              album_page(),
            ],
          ),
        ));
  }
}
