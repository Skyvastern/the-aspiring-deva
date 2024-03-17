extends CharacterBody3D
class_name NPC

var _history: Array
var is_ready_to_drop: bool = false

@export_group("Data")
@export_multiline var instruction: String
@export_multiline var details_format: String
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
var interact: NPC_Interact

var target: Node3D = null
@onready var target_y_rotation: float = global_rotation.y
@onready var rotate_speed: float = 0.1

@export_group("Movement")
@export var npc_movement: NPC_Movement
var yama_waypoints: Array[Node3D]
var heaven_waypoints: Array[Node3D]
var hell_waypoints: Array[Node3D]

@export_group("Kicked")
@export var npc_kicked: NPC_Kicked
@export var ready_timer: Timer
const READY_MIN_TIME: float = 1
const READY_MAX_TIME: float = 10


func _ready() -> void:
	Global.level.game_manager.npc_fate_decided.connect(_on_npc_fate_decided)
	ready_timer.timeout.connect(_on_ready_timer_timeout)
	
	go_through_yama_waypoints()
	ready_timer.wait_time = randf_range(READY_MIN_TIME, READY_MAX_TIME)


func _physics_process(_delta: float) -> void:
	# Rotation
	if target:
		_set_angle_towards_target()
	else:
		_set_angle_at_default_position()
	
	_apply_rotation()
	
	# Wait time before NPC drops in the hell world
	if interact and is_instance_valid(interact):
		ready_timer.paused = interact.is_screen_active()


func setup(data: Dictionary) -> void:
	voice = data["voice"]
	
	var details: String = details_format % [
		data["name"],
		data["age"],
		data["background_story"],
		data["nature"]["truthfulness"],
		data["nature"]["friendliness"],
		data["nature"]["talkative"]
	]
	
	_history.append_array([
		{"role": "system", "content": instruction},
		{"role": "system", "content": details}
	])


func go_through_yama_waypoints() -> void:
	npc_movement.begin_travel(
		yama_waypoints,
		func():
			Global.enable_interactability(self)
			Global.level.game_manager.npc_arrived.emit()
	)


func go_through_heaven_waypoints() -> void:
	npc_movement.begin_travel(heaven_waypoints)


func go_through_hell_waypoints() -> void:
	npc_movement.begin_travel(
		hell_waypoints,
		func():
			Global.enable_interactability(self)
			is_ready_to_drop = true
			
			print("Ready Time: " + str(ready_timer.wait_time))
			ready_timer.start()
			
			Global.level.game_manager.npc_preparing_to_drop.emit()
	)


func get_history() -> Array:
	return _history


func add_player_message(message: String) -> void:
	_history.append({
		"role": "user",
		"content": message
	})


func add_npc_message(message: String) -> void:
	_history.append({
		"role": "assistant",
		"content": message
	})


func _set_angle_towards_target() -> void:
	target_y_rotation = Global.get_angle_to_rotate_for_slerp(
		global_transform,
		target.global_transform.origin
	)


func _set_angle_at_default_position() -> void:
	target_y_rotation = 0


func _apply_rotation() -> void:
	var new_basis: Basis = Global.rotate_slerp(global_transform, target_y_rotation, rotate_speed)
	global_transform.basis = new_basis


func on_player_interactable() -> void:
	interact = interact_scene.instantiate()
	interact.setup(self, is_ready_to_drop)
	add_child(interact)


func on_player_not_interactable() -> void:
	if is_instance_valid(interact):
		interact.queue_free()


func _on_npc_fate_decided() -> void:
	Global.disable_interactability(self)


func get_kicked() -> void:
	Global.disable_interactability(self)
	set_physics_process(false)
	ready_timer.stop()
	
	npc_kicked.get_kicked()


func drop() -> void:
	Global.disable_interactability(self)
	set_physics_process(false)
	
	npc_kicked.drop()


func _on_ready_timer_timeout() -> void:
	drop()
