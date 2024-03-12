extends Node
class_name Level

@export var game_manager: GameManager
@export var pause_menu: PauseMenu


func _enter_tree() -> void:
	Global.level = self


func start_game(npcs_data: Array) -> void:
	game_manager.start(npcs_data)
