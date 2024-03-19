extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@export var audio_one_shot_scene: PackedScene
@export var clips: Node
@export var one_shots: Node

@export_group("Extras")
@export var mouse_click_stream: AudioStream
@export var window_stream: AudioStream


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


func reduce_volume() -> void:
	_change_volume(-30, 1)


func reset_volume() -> void:
	_change_volume(-15, 1)


func _change_volume(
					to: float,
					duration: float = 1.0,
					callback: Callable = func(): pass) -> void:
	
	var tween: Tween = create_tween()
	tween.tween_property(active_music_stream, "volume_db", to, duration)
	tween.tween_callback(callback)


func play_mouse_click_sound() -> void:
	play_audio_one_shot(mouse_click_stream)


func play_window_sound() -> void:
	play_audio_one_shot(window_stream, -5)
