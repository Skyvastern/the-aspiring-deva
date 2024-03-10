extends Node
class_name NPC_Movement

@export var speed: float = 10
@export var wait_timer: Timer

var npc: NPC
var waypoints: Array[Node3D]
var current_waypoint: Node3D
var index: int = -1

signal npc_started_walking
signal npc_ended_walking


func _ready() -> void:
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	_reset_state()
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	# Movement
	var target_pos: Vector3 = current_waypoint.global_position
	var dir: Vector3 = npc.global_position.direction_to(target_pos)
	npc.global_position += dir * speed * delta
	
	# Rotation
	npc.target = current_waypoint
	
	# Current Waypoint Reached
	if npc.global_position.distance_to(target_pos) < 1:
		wait_timer.start()
		set_physics_process(false)


func _reset_state() -> void:
	npc = null
	waypoints.clear()
	current_waypoint = null
	index = -1


func begin_travel(new_npc: NPC, new_waypoints: Array[Node3D]) -> void:
	_reset_state()
	
	npc = new_npc
	waypoints = new_waypoints
	update_current_waypoint()
	
	npc_started_walking.emit()


func update_current_waypoint() -> void:
	if index >= waypoints.size() - 1:
		npc_ended_walking.emit()
		print(npc.name + " : Destination reached!")
		
		return
	
	index += 1
	current_waypoint = waypoints[index]
	
	set_physics_process(true)


func _on_wait_timer_timeout() -> void:
	update_current_waypoint()
