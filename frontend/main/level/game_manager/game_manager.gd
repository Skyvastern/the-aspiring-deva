extends Node
class_name GameManager

signal next_npc_coming
signal npc_arrived
signal npc_fate_decided
signal npc_preparing_to_drop

@export_group("Data")
@export var all_npcs_data: Array
var index: int = -1
var right_judgements: int = 0

@export_group("References")
@export_file("*.tscn") var game_result_menu_scene_path: String
@export var npc_scene: PackedScene
@export var npc_parent: Node3D
var current_npc: NPC

@export_group("NPC Waypoints")
@export var yama_waypoints: Array[Node3D]
@export var heaven_waypoints: Array[Node3D]
@export var hell_waypoints: Array[Node3D]

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
	all_npcs_data = npcs_data.duplicate(true)
	all_npcs_data.shuffle()
	
	_reset_state()
	bring_next_npc()


func _reset_state() -> void:
	index = -1
	current_npc = null
	Global.clear_child_nodes(npc_parent)


func bring_next_npc() -> bool:
	if index >= all_npcs_data.size() - 1:
		print("No more NPCs left.")
		index = 0
		return false
	
	index += 1
	
	current_npc = npc_scene.instantiate()
	current_npc.setup(all_npcs_data[index])
	current_npc.yama_waypoints = yama_waypoints.duplicate(true)
	current_npc.heaven_waypoints = heaven_waypoints.duplicate(true)
	current_npc.hell_waypoints = hell_waypoints.duplicate(true)
	npc_parent.add_child(current_npc)
	
	next_npc_coming.emit()
	
	return true


func decide_fate(heaven: bool) -> void:
	npc_fate_decided.emit()
	
	Global.flash.flash_in()
	
	var player_choice: String = "Heaven" if heaven else "Hell"
	if player_choice == get_current_npc_data()["result"]:
		right_judgements += 1
	
	start_timer(
		0.5,
		func():
			Global.clear_child_nodes(world_parent)
			Global.player.reset_position_and_look_direction()
			
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
							if heaven:
								current_npc.go_through_heaven_waypoints()
							else:
								current_npc.go_through_hell_waypoints()
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
					
					if not bring_next_npc():
						start_timer(
							2,
							func():
								Global.player.is_controllable = false
								get_tree().paused = false
								
								Global.load_menu(
									Global.level,
									game_result_menu_scene_path,
									[
										{
											"name": "update_ui",
											"args": [right_judgements, all_npcs_data.size()]
										}
									]
								)
						)
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


func get_current_npc_data() -> Dictionary:
	return all_npcs_data[index]
