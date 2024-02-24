extends CharacterBody3D
class_name NPC

@export_group("Data")
@export_multiline var background_story: String
@export_enum(
	"alloy",
	"echo",
	"fable",
	"onyx",
	"nova",
	"shimmer"
) var voice: String = "onyx"

@export_group("References")
@export var interact_scene: PackedScene
@export var observation_area: Area3D
var interact: NPC_Interact

var target: Node3D = null
@onready var target_y_rotation: float = global_rotation.y
@onready var rotate_speed: float = 0.1


func _ready() -> void:
	observation_area.body_entered.connect(_on_observ_area_body_entered)
	observation_area.body_exited.connect(_on_observ_area_body_exited)
	Global.player.interactable.connect(_on_player_interactable)


func _physics_process(_delta: float) -> void:
	if target:
		_set_angle_towards_target()
	else:
		_set_angle_at_default_position()
	
	_apply_rotation()


func _set_angle_towards_target() -> void:
	target_y_rotation = Global.get_angle_to_rotate_for_slerp(
		global_transform,
		target.global_transform.origin
	)


func _set_angle_at_default_position() -> void:
	var current_y: float = rad_to_deg(abs(target_y_rotation))
	
	# Idea is to have Enemy point straight in either of the 4 directions
	# I'm sure there's a better way to find this out, but right now going with this approach
	# BUG: This also hides the jitter issue (will look for solution to this later)
	if current_y >= 0 and current_y < 45:
		current_y = 0
	elif current_y >= 45 and current_y < 90:
		current_y = 90
	elif current_y >= 90 and current_y < 135:
		current_y = 90
	elif current_y >= 135 and current_y < 180:
		current_y = 180
	elif current_y >= 180 and current_y < 225:
		current_y = 180
	elif current_y >= 225 and current_y < 270:
		current_y = 270
	elif current_y >= 270 and current_y < 315:
		current_y = 270
	elif current_y >= 315 and current_y < 360:
		current_y = 360
	
	current_y = deg_to_rad(current_y)
	current_y *= -1 if target_y_rotation < 0 else 1
	target_y_rotation = current_y


func _apply_rotation() -> void:
	var new_basis: Basis = Global.rotate_slerp(global_transform, target_y_rotation, rotate_speed)
	global_transform.basis = new_basis


func _on_observ_area_body_entered(body: Node3D) -> void:
	if body is Player:
		target = body


func _on_observ_area_body_exited(body: Node3D) -> void:
	if body is Player:
		target = null


func _on_player_interactable(interactable: bool) -> void:
	if interactable:
		interact = interact_scene.instantiate()
		interact.npc = self
		add_child(interact)
	else:
		if is_instance_valid(interact):
			interact.queue_free()
