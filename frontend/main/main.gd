extends Node
class_name Main

@export var pause_menu: PauseMenu


func _enter_tree() -> void:
	Global.main = self
