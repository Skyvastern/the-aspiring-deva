extends Control
class_name GameResultMenu

@export_group("Data")
@export_multiline var won_message: String
@export_multiline var lost_message: String

@export_group("UI")
@export var result_label: Label
@export var description_label: Label
@export var main_menu_btn: Button

@export_group("References")
@export_file("*.tscn") var main_menu_scene_path: String


func _ready() -> void:
	main_menu_btn.pressed.connect(_on_main_menu_btn_pressed)


func update_ui(right_judgements: int, total_judgements: int) -> void:
	result_label.text %= [right_judgements, total_judgements]
	
	if right_judgements >= 7:
		description_label.text = won_message % Global.player_name
	else:
		description_label.text = lost_message % Global.player_name


func _on_main_menu_btn_pressed() -> void:
	Global.load_menu(self, main_menu_scene_path)
