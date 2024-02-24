extends CharacterBody3D
class_name Player

@export var camera_3d: Camera3D
@export var mouse_senstivity: float = 0.005
@export var speed = 10.0
@export var jump_velocity = 25
@export var gravity: float = 100
@export var npc_detection_range: float = 3

const NPC_LAYER = 4
var is_interaction_available: bool = false
signal interactable


func _enter_tree() -> void:
	Global.player = self


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	# Check for NPCs
	_check_for_npcs()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_senstivity)
		camera_3d.rotate_x(-event.relative.y * mouse_senstivity)
		camera_3d.rotation_degrees.x = clampf(
			camera_3d.rotation_degrees.x,
			-90,
			90
		)


func _check_for_npcs() -> void:
	var from: Vector3 = camera_3d.global_position
	var to: Vector3 = from + (-camera_3d.global_transform.basis.z * npc_detection_range)
	var result: Dictionary = Global.create_ray(self, from, to, NPC_LAYER)
	
	if result.is_empty() == false:
		if is_interaction_available == false:
			is_interaction_available = true
			interactable.emit(true)
	else:
		if is_interaction_available:
			is_interaction_available = false
			interactable.emit(false)
