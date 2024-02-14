extends Control
class_name AudioRecord

@export var audio_record: AudioStreamPlayer
@export var audio_player: AudioStreamPlayer
@export var record_btn: Button
@export var play_btn: Button

var effect: AudioEffectRecord
var recording: AudioStreamWAV


func _ready() -> void:
	record_btn.pressed.connect(_on_record_btn_pressed)
	play_btn.pressed.connect(_on_play_btn_pressed)
	
	var index: int = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	
	audio_record.play()


func _on_record_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		
		_save_to_disk()
		
		record_btn.text = "Record"
		play_btn.disabled = false
	else:
		effect.set_recording_active(true)
		
		record_btn.text = "Stop"
		play_btn.disabled = true


func _on_play_btn_pressed() -> void:
	_play_recording()


func _play_recording() -> void:
	var _data: PackedByteArray = recording.get_data()
	audio_player.stream = recording
	audio_player.play()


func _save_to_disk() -> void:
	var wav_path: String = "C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\input.wav"
	var mp3_path: String = "C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\input.mp3"
	
	recording.save_to_wav(wav_path)
	Global.convert_wav_to_mp3(wav_path, mp3_path)
