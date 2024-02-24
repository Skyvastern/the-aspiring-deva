extends Control
class_name HUD

@export var crosshair: ColorRect


func _ready() -> void:
	Global.main.pause_menu.game_paused.connect(_on_game_paused)


func _on_game_paused(paused: bool) -> void:
	visible = !paused
