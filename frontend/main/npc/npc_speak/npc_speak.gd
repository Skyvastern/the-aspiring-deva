extends Node
class_name NPC_Speak

@export_group("UI")
@export var status: Status
@export var subtitles_label: Label
@export var continue_btn: Button
@export var close_btn: Button

@export_group("References")
@export_file("*.tscn") var audio_record_scene_path: String
@export var audio_player: AudioStreamPlayer
@export var textgen_api: TextgenAPI
@export var text_to_speech_api: TextToSpeechAPI

var player_message: String = ""
var npc_message: String = ""


func _ready() -> void:
	text_to_speech_api.processed.connect(_on_text_to_speech_api_processed)
	textgen_api.processed.connect(_on_textgen_api_processed)
	continue_btn.pressed.connect(_on_continue_btn_pressed)
	close_btn.pressed.connect(_on_close_btn_pressed)
	
	subtitles_label.text = ""


func interpret(new_player_message: String) -> void:
	player_message = new_player_message
	
	textgen_api.make_request(
		player_message,
		Global.active_npc.get_history()
	)


func _on_text_to_speech_api_processed(audio_stream: AudioStreamOggVorbis) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
	
	subtitles_label.text = npc_message
	
	status.hide_status()
	continue_btn.visible = true
	
	Global.active_npc.add_player_message(player_message)
	Global.active_npc.add_npc_message(npc_message)


func _on_textgen_api_processed(result: int, response_code: int, json: Dictionary) -> void:
	if result != 0 or response_code != 200:
		status.show_error("Error processing NPC response.")
		return
	
	npc_message = json["npc_message"]
	
	text_to_speech_api.make_request(
		npc_message,
		Global.active_npc.voice
	)


func _on_continue_btn_pressed() -> void:
	Global.load_scene(
		self,
		get_parent(),
		audio_record_scene_path
	)


func _on_close_btn_pressed() -> void:
	Global.active_npc.interact.close_interaction_screen()
	queue_free()
