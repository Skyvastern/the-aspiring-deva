extends Node


func convert_mp3_to_ogg(mp3_path: String, ogg_path: String) -> void:
	var output = []
	var exit_code = OS.execute("ffmpeg", ["-y", "-i", mp3_path, "-c:a", "libvorbis", ogg_path], output)
	
	if exit_code == 0:
		print("Successfully converted mp3 to ogg!")
	else:
		print("Conversion failed with exit code: " + str(exit_code))
		print("Ffmpeg output: " + str(output))


func save_file_to_disk(binary_data: PackedByteArray, output_path: String) -> void:
	var file = FileAccess.open(output_path, FileAccess.WRITE)
	file.store_buffer(binary_data)
	file.close()
