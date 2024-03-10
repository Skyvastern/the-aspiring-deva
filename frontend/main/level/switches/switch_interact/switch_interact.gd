extends Control
class_name SwitchInteract

@export var description: Label
var switch_type: String = ""


func setup(new_switch_type: String) -> void:
	switch_type = new_switch_type
	
	match switch_type:
		"Yama":
			description.text = "Return to Yama"
		"Heaven":
			description.text = "Send to Heaven"
		"Hell":
			description.text = "Send to Hell"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if switch_type == "Yama":
			Global.game_manager.return_to_yama()
		else:
			Global.game_manager.decide_fate(switch_type == "Heaven")
