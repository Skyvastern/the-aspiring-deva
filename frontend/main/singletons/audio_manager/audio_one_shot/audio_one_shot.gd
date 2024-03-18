extends AudioStreamPlayer
class_name AudioOneShot


func _ready() -> void:
	finished.connect(self.queue_free)
	play()
