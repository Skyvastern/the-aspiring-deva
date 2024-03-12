extends Node
class_name GameManager

@export_group("Data")
@export var all_npcs_data: Array
var index: int = -1

@export_group("References")
@export var npc_scene: PackedScene
@export var npc_parent: Node3D
var current_npc: NPC

@export_group("NPC Waypoints")
@export var entry_waypoints: Array[Node3D]
@export var exit_waypoints: Array[Node3D]

@export_group("World Transition")
@export var world_parent: Node3D
@export var world_yama_scene: PackedScene
@export var world_heaven_scene: PackedScene
@export var world_hell_scene: PackedScene
@export var timer: Timer
var timer_callback: Callable


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func start(npcs_data: Array) -> void:
	all_npcs_data = npcs_data
	
	_reset_state()
	bring_next_npc()


func _reset_state() -> void:
	index = -1
	current_npc = null
	Global.clear_child_nodes(npc_parent)


func bring_next_npc() -> void:
	if index >= all_npcs_data.size() - 1:
		print("No more NPCs left.")
		index = 0
		return
	
	index += 1
	
	current_npc = npc_scene.instantiate()
	current_npc.background_story = all_npcs_data[index]["background_story"]
	current_npc.voice = all_npcs_data[index]["voice"]
	current_npc.entry_waypoints = entry_waypoints.duplicate(true)
	current_npc.exit_waypoints = exit_waypoints.duplicate(true)
	
	npc_parent.add_child(current_npc)


func can_player_interact() -> bool:
	if current_npc and is_instance_valid(current_npc):
		return not current_npc.is_npc_walking
	
	return false


func decide_fate(heaven: bool) -> void:
	Global.flash.flash_in()
	
	start_timer(
		0.5,
		func():
			Global.clear_child_nodes(world_parent)
			
			if heaven:
				var world_heaven: Node3D = world_heaven_scene.instantiate()
				world_parent.add_child(world_heaven)
			else:
				var world_hell: Node3D = world_hell_scene.instantiate()
				world_parent.add_child(world_hell)
			
			start_timer(
				1,
				func():
					Global.flash.flash_out()
					
					start_timer(
						1,
						func():
							current_npc.go_through_exit_waypoints()
					)
			)
	)


func return_to_yama() -> void:
	Global.flash.flash_in()
	
	start_timer(
		0.5,
		func():
			Global.clear_child_nodes(world_parent)
			
			var world_yama: Node3D = world_yama_scene.instantiate()
			world_parent.add_child(world_yama)
			
			Global.clear_child_nodes(npc_parent)
			Global.player.reset_position_and_look_direction()
			
			start_timer(
				1,
				func():
					Global.flash.flash_out()
					bring_next_npc()
			)
	)


# NOTE: Not using get_tree().create_timer().timeout as it keeps running when tree is paused
func start_timer(wait_time: float, callback: Callable) -> void:
	timer.wait_time = wait_time
	timer_callback = callback
	timer.start()


func _on_timer_timeout() -> void:
	if timer_callback:
		timer_callback.call()
