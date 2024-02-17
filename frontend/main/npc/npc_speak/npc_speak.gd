extends Node
class_name NPC_Speak

@export var text_to_speech_api: TextToSpeechAPI
@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	text_to_speech_api.processed.connect(_on_text_to_speech_api_processed)


func speak(value: String) -> void:
	text_to_speech_api.make_request(value)


func _on_text_to_speech_api_processed(audio_stream: AudioStreamOggVorbis) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
