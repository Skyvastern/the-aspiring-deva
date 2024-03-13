extends Control
class_name SetupMenu

@export_group("UI")
@export var player_name_input: LineEdit
@export var confirm_btn: Button

@export_group("References")
@export_file("*.tscn") var main_menu_scene_path: String


func _ready() -> void:
	confirm_btn.pressed.connect(_on_confirm_btn_pressed)


func _on_confirm_btn_pressed() -> void:
	var player_name: String = player_name_input.text.strip_escapes().strip_edges()
	if player_name != "":
		Global.player_name = player_name
	
	Global.load_menu(self, main_menu_scene_path)
