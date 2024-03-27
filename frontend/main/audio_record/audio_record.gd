extends Control
class_name AudioRecord

@export_group("UI")
@export var text_edit: TextEdit
@export var record_btn: Button
@export var ask_btn: Button
@export var close_btn: Button
@export var status: Status

@export_group("References")
@export var audio_record: AudioStreamPlayer
@export var audio_player: AudioStreamPlayer
@export var speech_to_text_api: SpeechToTextAPI
@export_file("*.tscn") var npc_speak_scene_path: String

var effect: AudioEffectRecord
var recording: AudioStreamWAV


func _ready() -> void:
	close_btn.pressed.connect(_on_closed_btn_pressed)
	record_btn.pressed.connect(_on_record_btn_pressed)
	ask_btn.pressed.connect(_on_ask_btn_pressed)
	speech_to_text_api.processed.connect(_on_speech_to_text_processed)
	
	status.hide_status()
	
	var index: int = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	audio_record.play()


func _on_record_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		
		record_btn.text = "Processing"
		record_btn.disabled = true
		
		status.show_status("Processing")
		
		var base64: String = _get_audio_base64()
		speech_to_text_api.make_request(
			base64,
			Global.active_npc.get_history()
		)
	else:
		effect.set_recording_active(true)
		
		text_edit.editable = false
		text_edit.text = "Processing..."
		record_btn.text = "Stop"
		
		status.show_status("Recording")


func _on_play_btn_pressed() -> void:
	_play_recording()


func _play_recording() -> void:
	var _data: PackedByteArray = recording.get_data()
	audio_player.stream = recording
	audio_player.play()


func _get_audio_base64() -> String:
	# Save to disk
	recording.save_to_wav(Global.WAV_PATH)
	
	# Get data from the file
	var audio_file: FileAccess = FileAccess.open(Global.WAV_PATH, FileAccess.READ)
	var audio_data: PackedByteArray = audio_file.get_buffer(audio_file.get_length())
	audio_file.close()
	
	# Remove the saved file
	DirAccess.remove_absolute(Global.WAV_PATH)
	
	# Return base64 audio data
	return Marshalls.raw_to_base64(audio_data)


func _on_speech_to_text_processed(result: int, response_code: int, json: Dictionary) -> void:
	status.hide_status()
	
	text_edit.text = ""
	text_edit.editable = true
	record_btn.disabled = false
	record_btn.text = "Record"
	
	if result != 0 or response_code != 200:
		status.show_error("Error processing the audio.")
		return
	
	var transcript: String = json["text"]
	text_edit.text = transcript


func _on_ask_btn_pressed() -> void:
	Global.load_scene(
		self,
		get_parent(),
		npc_speak_scene_path,
		[
			{
				"name": "interpret",
				"args": [text_edit.text]
			}
		]
	)


func _on_closed_btn_pressed() -> void:
	Global.active_npc.interact.close_interaction_screen()
	
	effect.set_recording_active(false)
	queue_free()
