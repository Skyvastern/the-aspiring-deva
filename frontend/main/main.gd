extends Node
class_name Main


func _enter_tree() -> void:
	Global.main = self


func _ready() -> void:
	AudioManager.play("Main")
