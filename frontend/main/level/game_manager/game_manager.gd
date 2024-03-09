extends Node
class_name GameManager

@export_group("Data")
@export var all_npcs_data: Array[Dictionary]
var index: int = -1

@export_group("References")
@export var npc_scene: PackedScene
@export var npc_parent: Node3D
var current_npc: NPC

@export_group("NPC Waypoints")
@export var entry_waypoints: Array[Node3D]
@export var exit_waypoints: Array[Node3D]


func _enter_tree() -> void:
	Global.game_manager = self


func _ready() -> void:
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


func decide_fate(heaven: bool) -> void:
	if heaven:
		print("NPC goes to heaven!")
	else:
		print("NPC goes to hell.")
	
	current_npc.go_through_exit_waypoints()
	await get_tree().create_timer(3).timeout
	
	Global.clear_child_nodes(npc_parent)
	bring_next_npc()
