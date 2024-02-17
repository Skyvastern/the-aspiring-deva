extends Control
class_name AudioRecord

@export_group("UI")
@export var text_edit: TextEdit
@export var record_btn: Button
@export var ask_btn: Button

@export_group("References")
@export var audio_record: AudioStreamPlayer
@export var audio_player: AudioStreamPlayer
@export var speech_to_text_api: SpeechToTextAPI
@export_file("*.tscn") var npc_speak_scene_path: String

var effect: AudioEffectRecord
var recording: AudioStreamWAV


func _ready() -> void:
	record_btn.pressed.connect(_on_record_btn_pressed)
	ask_btn.pressed.connect(_on_ask_btn_pressed)
	speech_to_text_api.processed.connect(_on_speech_to_text_processed)
	
	var index: int = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	
	audio_record.play()


func _on_record_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		
		record_btn.text = "Processing..."
		record_btn.disabled = true
		
		_save_to_disk()
		_perform_speech_to_text()
	else:
		effect.set_recording_active(true)
		
		text_edit.editable = false
		text_edit.text = "Processing..."
		record_btn.text = "Stop"


func _on_play_btn_pressed() -> void:
	_play_recording()


func _play_recording() -> void:
	var _data: PackedByteArray = recording.get_data()
	audio_player.stream = recording
	audio_player.play()


func _save_to_disk() -> void:
	var wav_path: String = "C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\input.wav"
	recording.save_to_wav(wav_path)


func _perform_speech_to_text() -> void:
	var audio_file: FileAccess = FileAccess.open("C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\input.wav", FileAccess.READ)
	var audio_data: PackedByteArray = audio_file.get_buffer(audio_file.get_length())
	audio_file.close()
	
	var base64: String = Marshalls.raw_to_base64(audio_data)
	speech_to_text_api.make_request(base64)


func _on_speech_to_text_processed(json: Dictionary) -> void:
	var transcript: String = json["text"]
	text_edit.text = transcript
	
	text_edit.editable = true
	record_btn.disabled = false
	record_btn.text = "Record"


func _on_ask_btn_pressed() -> void:
	Global.load_menu(
		self,
		npc_speak_scene_path,
		[
			{
				"name": "interpret",
				"args": [text_edit.text]
			}
		]
	)
