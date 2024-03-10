extends Control
class_name SwitchInteract

@export var description: Label
var switch: Switch


func setup(new_switch: Switch) -> void:
	switch = new_switch
	
	match switch.switch_type:
		"Yama":
			description.text = "Return to Yama"
		"Heaven":
			description.text = "Send to Heaven"
		"Hell":
			description.text = "Send to Hell"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		switch.disable_further_interaction()
		
		if switch.switch_type == "Yama":
			Global.game_manager.return_to_yama()
		else:
			Global.game_manager.decide_fate(switch.switch_type == "Heaven")
