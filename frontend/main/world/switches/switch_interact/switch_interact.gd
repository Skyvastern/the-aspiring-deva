extends Control
class_name SwitchInteract

@export var description: Label
var switch_type: String = ""


func setup(new_switch_type: String) -> void:
	switch_type = new_switch_type
	
	match switch_type:
		"Heaven":
			description.text = "Send to Heaven"
		"Hell":
			description.text = "Send to Hell"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		Global.game_manager.decide_fate(
			switch_type == "Heaven"
		)
