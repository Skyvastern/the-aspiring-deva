extends Node

var active_music_stream: AudioStreamPlayer

@export var audio_one_shot_scene: PackedScene
@export var clips: Node
@export var one_shots: Node


func play(audio_name: String, from_position: float = 0.0) -> void:
	if active_music_stream:
		if active_music_stream.name == audio_name:
			return
		
		if active_music_stream.playing:
			active_music_stream.stop()
	
	active_music_stream = clips.get_node(audio_name)
	active_music_stream.play(from_position)


func play_audio_one_shot(audio_stream: AudioStream, volume_db: float = 0.0) -> AudioOneShot:
	var audio_one_shot: AudioOneShot = audio_one_shot_scene.instantiate()
	audio_one_shot.stream = audio_stream
	audio_one_shot.volume_db = volume_db
	
	one_shots.add_child(audio_one_shot)
	return audio_one_shot
