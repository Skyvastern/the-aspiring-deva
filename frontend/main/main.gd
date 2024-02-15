extends Node

@export var text_to_speech_api: TextToSpeechAPI
@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	text_to_speech_api.processed.connect(_on_text_to_speech_api_processed)
	text_to_speech_api.make_request("I am so happy today!")


func _on_text_to_speech_api_processed(audio_stream: AudioStreamOggVorbis) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
