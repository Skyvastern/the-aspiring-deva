extends Control
class_name NPC_Speak_Auto

@export_group("UI")
@export var status: Status
@export var audio_player: AudioStreamPlayer
@export var subtitles_label: Label
@export var continue_btn: Button
@export var close_btn: Button

@export_group("References")
@export var speech_to_speech_api: SpeechToSpeechAPI
@export_file("*.tscn") var audio_record_auto_path: String


func _ready() -> void:
	speech_to_speech_api.processed.connect(_on_speech_to_speech_api_processed)
	continue_btn.pressed.connect(_on_continue_btn_pressed)
	close_btn.pressed.connect(_on_close_btn_pressed)


func interpret(audio_base64: String) -> void:
	speech_to_speech_api.make_request(
		Global.active_npc.voice,
		audio_base64,
		Global.active_npc.get_history()
	)


func _on_speech_to_speech_api_processed(result: int, response_code: int, json: Dictionary) -> void:
	if result != 0 or response_code != 200:
		status.show_error("Error processing the audio.")
		return
	
	var audio_base64: String = json["audio_base64"]
	var player_message: String = json["player_message"]
	var npc_message: String = json["npc_message"]
	
	# Update UI
	status.hide_status()
	continue_btn.visible = true
	
	# Set the subtitles
	subtitles_label.text = npc_message
	
	# Play the audio
	var audio_data: PackedByteArray = Marshalls.base64_to_raw(audio_base64)
	var audio_stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_buffer(audio_data)
	audio_player.stream = audio_stream
	audio_player.play()
	
	# Update history
	Global.active_npc.add_player_message(player_message)
	Global.active_npc.add_npc_message(npc_message)


func _on_continue_btn_pressed() -> void:
	Global.load_scene(self, get_parent(), audio_record_auto_path, [])


func _on_close_btn_pressed() -> void:
	Global.active_npc.interact.close_interaction_screen()
	queue_free()
