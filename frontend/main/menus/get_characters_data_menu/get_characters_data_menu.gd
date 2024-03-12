extends Control
class_name GetCharactersDataMenu

@export_group("Data")
@export_multiline var instructions: String

@export_group("References")
@export var get_characters_api: GetCharactersAPI
@export_file("*.tscn") var level_scene_path: String


func _ready() -> void:
	get_characters_api.processed.connect(_on_get_characters_processed)
	get_characters_api.make_request(instructions)


func _on_get_characters_processed(json: Dictionary) -> void:
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
