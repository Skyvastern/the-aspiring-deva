extends HTTPRequest
class_name TextToSpeechAPI

signal processed
const URL: String = "http://127.0.0.1:8000/text-to-speech/"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(value: String) -> void:
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var request_payload: String = JSON.stringify({
		"text": value,
		"voice": "echo"
	})
	
	request(URL, headers, HTTPClient.METHOD_POST, request_payload)


func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var audio_stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_buffer(body)
	processed.emit(audio_stream)
