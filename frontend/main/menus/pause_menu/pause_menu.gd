extends Control
class_name PauseMenu

signal game_paused

@export_group("UI")
@export var resume_btn: Button
@export var exit_btn: Button

@export_group("References")
@export_file("*.tscn") var main_menu_scene_path: String


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	resume_btn.pressed.connect(_on_resume_btn_pressed)
	exit_btn.pressed.connect(_on_exit_btn_pressed)
	
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible


func _on_visibility_changed() -> void:
	get_tree().paused = visible
	game_paused.emit(visible)


func _on_resume_btn_pressed() -> void:
	visible = false


func _on_exit_btn_pressed() -> void:
	get_tree().paused = false
	Global.load_menu(
		Global.level,
		main_menu_scene_path
	)
