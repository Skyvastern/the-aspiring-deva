extends Node

const WAV_PATH: String = "user://audio.wav"

var main: Main
var player_name: String = "Default"
var level: Level
var player: Player
var flash: Flash
const INTERACTABLE_LAYER: int = 16

signal active_npc_updated
var active_npc: NPC:
	get:
		return active_npc
	set(value):
		active_npc = value
		
		if active_npc == null:
			active_npc_updated.emit(active_npc)
		else:
			active_npc_updated.emit(active_npc)


func save_file_to_disk(binary_data: PackedByteArray, output_path: String) -> void:
	var file = FileAccess.open(output_path, FileAccess.WRITE)
	file.store_buffer(binary_data)
	file.close()


func load_menu(current_menu: Node, new_menu_path: String, new_menu_callbacks: Array = []) -> void:
	var menu_res: Resource = load(new_menu_path)
	var menu: Node = menu_res.instantiate()
	main.add_child(menu)
	
	for fn in new_menu_callbacks:
		var fn_name = fn["name"]
		var fn_args = fn["args"]
		menu.callv(fn_name, fn_args)
	
	current_menu.queue_free()


func load_scene(current_scene: Node, parent_scene: Node, new_scene_path: String, new_scene_callbacks: Array = []) -> void:
	var res: Resource = load(new_scene_path)
	var new_scene: Node = res.instantiate()
	parent_scene.add_child(new_scene)
	
	for fn in new_scene_callbacks:
		var fn_name = fn["name"]
		var fn_args = fn["args"]
		new_scene.callv(fn_name, fn_args)
	
	current_scene.queue_free()


func get_angle_to_rotate_for_slerp(t: Transform3D, target: Vector3) -> float:
	var towards: Vector3 = t.origin.direction_to(target)
	return Vector3.FORWARD.signed_angle_to(towards, Vector3.UP)


func rotate_slerp(t: Transform3D, angle: float, slerp_amount: float) -> Basis:
	# Current Quat
	var basis: Basis = t.basis.orthonormalized()
	var start_quat: Quaternion = basis.get_rotation_quaternion()
	
	# Target Quat
	var target_quat: Quaternion = Quaternion(Vector3.UP, angle)
	
	# Interpolate
	var result_quat: Quaternion = start_quat.slerp(target_quat, slerp_amount)
	return Basis(result_quat)


func create_ray(node3d: Node3D, from: Vector3, to: Vector3, collision_mask: int, exclude = []) -> Dictionary:
	var space_state: PhysicsDirectSpaceState3D = node3d.get_world_3d().direct_space_state
	var query_params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to, collision_mask, exclude)
	var result: Dictionary = space_state.intersect_ray(query_params)
	return result


func clear_child_nodes(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
