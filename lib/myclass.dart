import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class myclass extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  RxList<SongModel> song = RxList();
  RxList<SongModel> songbyartist = RxList();
  RxList<FavoritesEntity> fav_list = RxList();
  RxList<SongModel> songbyalbum = RxList();
  RxList<ArtistModel> artist = RxList();
  RxList<AlbumModel> album = RxList();
  RxInt cur_index = 0.obs;
  static AudioPlayer player = AudioPlayer();
  RxDouble duration = 0.0.obs;
  RxDouble dur = 0.0.obs;
  RxBool temp = true.obs;
  RxBool is_fav = false.obs;

  get_song() async {
    song.value = await _audioQuery.querySongs();
    return song;
  }

  artist_get() async {
    artist.value = await _audioQuery.queryArtists();
    return artist;
  }

  album_get() async {
    album.value = await _audioQuery.queryAlbums();
    return album;
  }

  getbyartist(int artistid) async {
    songbyartist.value =
        await _audioQuery.queryAudiosFrom(AudiosFromType.ARTIST_ID, artistid);
    return songbyartist;
  }

  getbyalbum(int albumid) async {
    songbyalbum.value =
        await _audioQuery.queryAudiosFrom(AudiosFromType.ALBUM_ID, albumid);
    return songbyalbum;
  }

  check_fav() async {
    is_fav.value = await OnAudioRoom()
        .checkIn(RoomType.FAVORITES, song.value[cur_index.value].id);
  }
  get_fav()
  async {
       fav_list.value= await OnAudioRoom().queryFavorites();
        return fav_list;
  }

  getDuration(){
    player.onPositionChanged.listen((Duration d) {
      duration.value = d.inMilliseconds.toDouble();
      dur.value = d.inSeconds.toDouble();
    });
  }
}
