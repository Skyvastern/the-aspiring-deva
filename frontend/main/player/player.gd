extends CharacterBody3D
class_name Player

@export var camera_3d: Camera3D
@export var mouse_senstivity: float = 0.005
@export var speed = 10.0
@export var jump_velocity = 25
@export var gravity: float = 100
@export var npc_detection_range: float = 5

var interactable_node: Node
var prev_interactable_node: Node

@onready var player_default_pos: Vector3 = position
@onready var player_default_rot_y: float = rotation.y
@onready var camera_default_rot_x: float = camera_3d.rotation.x


var is_controllable: bool = false:
	get:
		return is_controllable
	set(value):
		is_controllable = value
		
		if is_controllable:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _enter_tree() -> void:
	Global.player = self


func _ready() -> void:
	Global.level.pause_menu.game_paused.connect(_on_game_paused)
	Global.active_npc_updated.connect(_on_active_npc_updated)
	
	is_controllable = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity * int(is_controllable)

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed * int(is_controllable)
		velocity.z = direction.z * speed * int(is_controllable)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	# Check for Interactable Nodes
	_check_for_interactable_nodes()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_controllable:
		rotate_y(-event.relative.x * mouse_senstivity)
		camera_3d.rotate_x(-event.relative.y * mouse_senstivity)
		camera_3d.rotation_degrees.x = clampf(
			camera_3d.rotation_degrees.x,
			-90,
			90
		)


func _check_for_interactable_nodes() -> void:
	var from: Vector3 = camera_3d.global_position
	var to: Vector3 = from + (-camera_3d.global_transform.basis.z * npc_detection_range)
	var result: Dictionary = Global.create_ray(self, from, to, Global.INTERACTABLE_LAYER)
	
	if result.is_empty() == false:
		interactable_node = result["collider"]
		
		if interactable_node != prev_interactable_node:
			if prev_interactable_node and is_instance_valid(prev_interactable_node):
				if prev_interactable_node.has_method("on_player_not_interactable"):
					prev_interactable_node.on_player_not_interactable()
			
			if interactable_node.has_method("on_player_interactable"):
				interactable_node.on_player_interactable()
			
			prev_interactable_node = interactable_node
	else:
		if interactable_node and is_instance_valid(interactable_node):
			if interactable_node.has_method("on_player_not_interactable"):
				interactable_node.on_player_not_interactable()
			
			interactable_node = null
			prev_interactable_node = null


func _on_game_paused(paused: bool) -> void:
	if paused:
		is_controllable = false
	elif paused == false and Global.active_npc != null:
		is_controllable = false
	else:
		is_controllable = true


func _on_active_npc_updated(npc: NPC) -> void:
	if npc == null:
		is_controllable = true
	else:
		is_controllable = false


func reset_position_and_look_direction() -> void:
	position = player_default_pos
	rotation.y = player_default_rot_y
	camera_3d.rotation.x = camera_default_rot_x
