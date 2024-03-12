extends Node
class_name Level

@export var pause_menu: PauseMenu


func _enter_tree() -> void:
	Global.level = self
