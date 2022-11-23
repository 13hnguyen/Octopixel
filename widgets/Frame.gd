extends CheckBox

export var frameNumber: int = 1

signal frame_changed(num)

func _ready() -> void:
	self.text = str(frameNumber)

func _on_CheckBox_pressed() -> void:
	emit_signal("frame_changed", frameNumber)
