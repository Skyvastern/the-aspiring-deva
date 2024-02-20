extends Node
class_name NPC_Speak_Auto

@export_group("UI")
@export var status: Label
@export var audio_player: AudioStreamPlayer
@export var subtitles_label: Label
@export var continue_btn: Button

@export_group("References")
@export var speech_to_speech_api: SpeechToSpeechAPI
@export_file("*.tscn") var audio_record_auto_path: String


func _ready() -> void:
	speech_to_speech_api.processed.connect(_on_speech_to_speech_api_processed)
	continue_btn.pressed.connect(_on_continue_btn_pressed)


func interpret(audio_base64: String) -> void:
	speech_to_speech_api.make_request(audio_base64)


func _on_speech_to_speech_api_processed(json: Dictionary) -> void:
	# Hide the status
	status.visible = false
	
	# Set the subtitles
	var subtitle: String = json["subtitle"]
	subtitles_label.text = subtitle
	
	# Play the audio
	var audio_base64: String = json["audio_base64"]
	var audio_data: PackedByteArray = Marshalls.base64_to_raw(audio_base64)
	var audio_stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_buffer(audio_data)
	audio_player.stream = audio_stream
	audio_player.play()


func _on_continue_btn_pressed() -> void:
	Global.load_menu(self, audio_record_auto_path, [])
