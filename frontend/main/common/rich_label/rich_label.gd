extends RichTextLabel
class_name RichLabel


func _ready() -> void:
	meta_clicked.connect(_on_meta_clicked)


func _on_meta_clicked(meta: Variant) -> void:
	var url: String = str(meta)
	OS.shell_open(url)
