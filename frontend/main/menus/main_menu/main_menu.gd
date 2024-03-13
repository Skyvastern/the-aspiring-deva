extends Control
class_name MainMenu

@export_group("UI")
@export var player_name_label: Label
@export var start_btn: Button
@export var exit_btn: Button

@export_group("References")
@export_file("*.tscn") var game_mode_menu_scene_path: String


func _ready() -> void:
	start_btn.pressed.connect(_on_start_btn_pressed)
	exit_btn.pressed.connect(_on_exit_btn_pressed)
	
	_set_player_name_label()


func _set_player_name_label() -> void:
	player_name_label.text %= Global.player_name


func _on_start_btn_pressed() -> void:
	Global.load_menu(self, game_mode_menu_scene_path)


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
