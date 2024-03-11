extends Control
class_name GetCharactersDataMenu

@export_group("Data")
@export_multiline var instructions: String

@export_group("References")
@export var get_characters_api: GetCharactersAPI


func _ready() -> void:
	get_characters_api.processed.connect(_on_get_characters_processed)


func _on_get_characters_processed(json: Dictionary) -> void:
	print(json)
