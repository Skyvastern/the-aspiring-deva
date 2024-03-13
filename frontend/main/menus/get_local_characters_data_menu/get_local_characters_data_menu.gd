extends Control
class_name GetLocalCharactersDataMenu

@export_group("References")
@export_file("*.tscn") var level_scene_path: String


func _ready() -> void:
	_load_data()


func _load_data() -> void:
	const PATH: String = "res://default_characters_data.json"
	
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var data: String = file.get_as_text()
	var json: Dictionary = JSON.parse_string(data)
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
