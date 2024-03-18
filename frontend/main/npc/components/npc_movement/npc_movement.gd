extends Node
class_name NPC_Movement

@export var npc: NPC
@export var speed: float = 5
@export var wait_timer: Timer
@export var character_model: CharacterModel
const ANIM_BLEND: float = 0.15

var waypoints: Array[Node3D]
var current_waypoint: Node3D
var index: int = -1
var on_destination_reached: Callable = func(): pass


func _ready() -> void:
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	_reset_state()
	Global.disable_interactability(npc)
	
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	# Movement
	var target_pos: Vector3 = current_waypoint.global_position
	var dir: Vector3 = npc.global_position.direction_to(target_pos)
	npc.velocity = dir * speed
	npc.move_and_slide()
	
	# Rotation
	npc.target = current_waypoint
	
	# Current Waypoint Reached
	if npc.global_position.distance_to(target_pos) < 1:
		character_model.play_animation("_idle", ANIM_BLEND)
		
		if index < waypoints.size() - 1:
			wait_timer.start()
		else:
			# Don't wait for timer, directly finish traversal
			update_current_waypoint()
		
		set_physics_process(false)


func _reset_state() -> void:
	waypoints.clear()
	current_waypoint = null
	index = -1
	on_destination_reached = func(): pass


func begin_travel(new_waypoints: Array[Node3D], on_destination_reached_callable: Callable = func(): pass) -> void:
	_reset_state()
	
	waypoints = new_waypoints
	on_destination_reached = on_destination_reached_callable
	update_current_waypoint()


func update_current_waypoint() -> void:
	if index >= waypoints.size() - 1:
		on_destination_reached.call()
		return
	
	index += 1
	current_waypoint = waypoints[index]
	
	character_model.play_animation("walking", ANIM_BLEND, 1)
	set_physics_process(true)


func _on_wait_timer_timeout() -> void:
	update_current_waypoint()
