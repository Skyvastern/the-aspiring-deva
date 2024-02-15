extends Node


func convert_wav_to_mp3(wav_path: String, mp3_path: String) -> void:
	var output = []
	var exit_code = OS.execute("ffmpeg", ["-y", "-i", wav_path, mp3_path], output)
	
	if exit_code == 0:
		print("Successfully converted wav to mp3!")
	else:
		print("Conversion failed with exit code: " + str(exit_code))
		print("Ffmpeg output: " + str(output))


func save_file_to_disk(binary_data: PackedByteArray, output_path: String) -> void:
	var file = FileAccess.open(output_path, FileAccess.WRITE)
	file.store_buffer(binary_data)
	file.close()
