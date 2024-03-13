extends Control
class_name GameModeMenu

@export_group("UI")
@export var play_btn: Button
@export var play_generate_btn: Button

@export_group("References")
@export_file("*.tscn") var get_characters_data_menu_scene_path: String


func _ready() -> void:
	play_btn.pressed.connect(_on_play_btn_pressed)
	play_generate_btn.pressed.connect(_on_play_generate_btn_pressed)


func _on_play_btn_pressed() -> void:
	pass


func _on_play_generate_btn_pressed() -> void:
	Global.load_menu(self, get_characters_data_menu_scene_path)
