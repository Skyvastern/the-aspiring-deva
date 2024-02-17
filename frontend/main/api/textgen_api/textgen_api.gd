extends HTTPRequest
class_name TextgenAPI

signal processed
const URL: String = "http://127.0.0.1:8000/textgen/"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(question: String) -> void:
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var request_payload: String = JSON.stringify({
		"question": question
	})
	
	request(URL, headers, HTTPClient.METHOD_POST, request_payload)


func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	processed.emit(json)
