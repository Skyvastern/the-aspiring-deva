extends Control
class_name NPC_Details_Panel

@export_group("UI")
@export var name_label: Label
@export var age_label: Label
@export var background_story_label: Label


func update_ui(npc_name: String, npc_age: int, background_story: String) -> void:
	name_label.text %= npc_name
	age_label.text %= npc_age
	background_story_label.text %= background_story
