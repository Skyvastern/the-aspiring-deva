extends Node

var main: Main


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
