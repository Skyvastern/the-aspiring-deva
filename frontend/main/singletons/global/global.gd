extends Node


func save_file_to_disk(binary_data: PackedByteArray, output_path: String) -> void:
	var file = FileAccess.open(output_path, FileAccess.WRITE)
	file.store_buffer(binary_data)
	file.close()
