extends HTTPRequest
class_name SpeechToTextAPI

signal processed
var URL: String = ENV.BASE_URL + "/speech-to-text"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(audio_base64: String, history: Array) -> void:
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var request_payload: String = JSON.stringify({
		"audio_base64": audio_base64,
		"history": history
	})
	
	request(URL, headers, HTTPClient.METHOD_POST, request_payload)


func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	processed.emit(json)
