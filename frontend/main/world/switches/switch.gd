extends CSGCombiner3D
class_name Switch

@export_enum("Heaven", "Hell") var switch_type: String = "Heaven"
@export var switch_interact_scene: PackedScene
var switch_interact: SwitchInteract


func on_player_interactable() -> void:
	switch_interact = switch_interact_scene.instantiate()
	switch_interact.setup(switch_type)
	
	add_child(switch_interact)


func on_player_not_interactable() -> void:
	if is_instance_valid(switch_interact):
		switch_interact.queue_free()
