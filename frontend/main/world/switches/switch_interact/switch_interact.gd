extends Control
class_name SwitchInteract

@export var description: Label


func setup(switch_type: String) -> void:
	match switch_type:
		"Heaven":
			description.text = "Send to Heaven"
		"Hell":
			description.text = "Send to Hell"
