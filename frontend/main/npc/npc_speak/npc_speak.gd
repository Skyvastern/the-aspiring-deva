extends Node
class_name NPC_Speak

@export_group("UI")
@export var npc_response: Label
@export var continue_btn: Button

@export_group("References")
@export_file("*.tscn") var audio_record_scene_path: String
@export var audio_player: AudioStreamPlayer
@export var textgen_api: TextgenAPI
@export var text_to_speech_api: TextToSpeechAPI

var reply: String = ""


func _ready() -> void:
	text_to_speech_api.processed.connect(_on_text_to_speech_api_processed)
	textgen_api.processed.connect(_on_textgen_api_processed)
	continue_btn.pressed.connect(_on_continue_btn_pressed)
	
	npc_response.text = ""


func interpret(question: String) -> void:
	npc_response.text = "Interpreting..."
	textgen_api.make_request(question)


func speak(value: String) -> void:
	text_to_speech_api.make_request(value)


func _on_text_to_speech_api_processed(audio_stream: AudioStreamOggVorbis) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
	
	npc_response.text = reply


func _on_textgen_api_processed(json: Dictionary) -> void:
	reply = json["message"]["content"]
	speak(reply)


func _on_continue_btn_pressed() -> void:
	Global.load_menu(self, audio_record_scene_path)
