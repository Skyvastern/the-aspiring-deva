extends HTTPRequest
class_name TextToSpeechAPI

signal processed
const URL: String = "https://api.openai.com/v1/audio/speech"
const MP3_PATH: String = "C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\output.mp3"
const OGG_PATH: String = "C:\\Users\\Arpit Srivastava\\Desktop\\Audio\\output.ogg"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(value: String) -> void:
	var headers: PackedStringArray = [
		"Authorization: Bearer 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",
		"Content-Type: application/json"
	]
	
	var request_payload: String = JSON.stringify({
		"model": "tts-1",
		"input": value,
		"voice": "echo"
	})
	
	request(URL, headers, HTTPClient.METHOD_POST, request_payload)


func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	Global.save_file_to_disk(body, MP3_PATH)
	Global.convert_mp3_to_ogg(MP3_PATH, OGG_PATH)
	var audio_stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(OGG_PATH)
	
	processed.emit(audio_stream)
