extends TextureButton
class_name BackButton

@export_file("*.tscn") var prev_menu_path: String
@export var current_menu: Node


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	AudioManager.play_mouse_click_sound()
	Global.load_menu(current_menu, prev_menu_path)
