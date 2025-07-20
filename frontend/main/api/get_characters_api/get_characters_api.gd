extends HTTPRequest
class_name GetCharactersAPI

signal processed
var URL: String = ENV.BASE_URL + "/get-random-characters"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request() -> void:
	request(URL)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json: Dictionary = {}
	
	if result == 0 and response_code == 200:
		json = JSON.parse_string(body.get_string_from_utf8())
	
	processed.emit(result, response_code, json)
