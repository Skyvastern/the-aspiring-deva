extends Node

const WAV_PATH: String = "user://audio.wav"

var main: Main
var active_npc: NPC

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
