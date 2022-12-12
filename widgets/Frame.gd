extends Control

export var frameNumber: int = 1

var duration: int = 200 #in ms

onready var label: Label = $Label
onready var checkbox: CheckBox = $CheckBox


signal frame_changed(num)

func _ready() -> void:
	label.text = str(frameNumber)

func _on_CheckBox_pressed() -> void:
	emit_signal("frame_changed", frameNumber)

func setPressed(ispressed: bool) -> void:
	checkbox.pressed = ispressed
