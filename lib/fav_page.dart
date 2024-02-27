import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_player/fav_song.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';

import 'myclass.dart';

class fav_page extends StatefulWidget {
  const fav_page({super.key});

  @override
  State<fav_page> createState() => _fav_pageState();
}

class _fav_pageState extends State<fav_page> {
  myclass m = Get.put(myclass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: m.get_fav(), builder: (context, snapshot) {
         if(snapshot.connectionState==ConnectionState.done){
           List<FavoritesEntity> l=snapshot.data  as List<FavoritesEntity>;
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return fav_song();
                },));
              },
              child: ListTile(
                title: Text("Fav"),
                leading: Text("${l.length}"),
              ),
            );
         }
         else
           {
              return CircularProgressIndicator();
           }
      },),
      
    );
  }
}
