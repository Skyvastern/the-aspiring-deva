extends Control
class_name GetCharactersDataMenu

@export_group("Data")
@export_multiline var instructions: String

@export_group("UI")
@export var status: Status

@export_group("References")
@export var get_characters_api: GetCharactersAPI
@export_file("*.tscn") var level_scene_path: String


func _ready() -> void:
	get_characters_api.processed.connect(_on_get_characters_processed)
	get_characters_api.make_request(instructions)


func _on_get_characters_processed(result: int, response_code: int, json: Dictionary) -> void:
	if result != 0 or response_code != 200:
		status.show_error("Error generating character data.")
		return
	
	var characters: Array = json["characters"]
	
	Global.load_menu(
		self,
		level_scene_path,
		[
			{
				"name": "start_game",
				"args": [characters]
			}
		]
	)
