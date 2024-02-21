extends Control
class_name AudioRecordAuto

@export_group("UI")
@export var speak_btn: Button

@export_group("References")
@export var audio_record: AudioStreamPlayer
@export var audio_player: AudioStreamPlayer
@export_file("*.tscn") var npc_speak_auto_scene_path: String

var effect: AudioEffectRecord
var recording: AudioStreamWAV


func _ready() -> void:
	speak_btn.pressed.connect(_on_speak_btn_pressed)
	
	var index: int = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	
	audio_record.play()


func _on_speak_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		
		speak_btn.text = "Processing..."
		speak_btn.disabled = true
		
		var base64: String = _get_audio_base64()
		
		Global.load_scene(
			self,
			get_parent(),
			npc_speak_auto_scene_path,
			[
				{
					"name": "interpret",
					"args": [base64]
				}
			]
		)
	else:
		effect.set_recording_active(true)
		speak_btn.text = "Stop"


func _get_audio_base64() -> String:
	# Save to disk
	const WAV_PATH: String = "user://audio.wav"
	recording.save_to_wav(WAV_PATH)
	
	# Get data from the file
	var audio_file: FileAccess = FileAccess.open(WAV_PATH, FileAccess.READ)
	var audio_data: PackedByteArray = audio_file.get_buffer(audio_file.get_length())
	audio_file.close()
	
	# Remove the saved file
	DirAccess.remove_absolute(WAV_PATH)
	
	# Return base64 audio data
	return Marshalls.raw_to_base64(audio_data)
