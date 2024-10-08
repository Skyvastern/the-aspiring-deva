extends HTTPRequest
class_name TextgenAPI

signal processed
var URL: String = ENV.BASE_URL + "/textgen"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(player_message: String, history: Array) -> void:
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var request_payload: String = JSON.stringify({
		"player_message": player_message,
		"history": history
	})
	
	request(URL, headers, HTTPClient.METHOD_POST, request_payload)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json: Dictionary = {}
	
	if result == 0 and response_code == 200:
		json = JSON.parse_string(body.get_string_from_utf8())
	
	processed.emit(result, response_code, json)
