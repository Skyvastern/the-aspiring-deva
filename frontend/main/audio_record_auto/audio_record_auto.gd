extends Control
class_name AudioRecordAuto

@export_group("UI")
@export var stop_btn: Button

@export_group("References")
@export var audio_record: AudioStreamPlayer
@export var audio_player: AudioStreamPlayer
@export_file("*.tscn") var npc_speak_auto_scene_path: String

var effect: AudioEffectRecord
var recording: AudioStreamWAV


func _ready() -> void:
	stop_btn.pressed.connect(_on_stop_btn_pressed)
	
	_setup()
	_start_recording()


func _setup() -> void:
	var index: int = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)


func _start_recording() -> void:
	audio_record.play()
	effect.set_recording_active(true)


func _on_stop_btn_pressed() -> void:
	if effect.is_recording_active():
		stop_btn.disabled = true
		
		recording = effect.get_recording()
		effect.set_recording_active(false)
		
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
		push_warning("Audio recording was off!")


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
