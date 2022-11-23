extends Control

onready var canvas: DefaultCanvas = $"%AnimationCanvas"
onready var frameBox: HBoxContainer = $VBoxContainer/Frames

onready var emptyFrame: PackedScene = preload("res://widgets/Frame.tscn")

var currentFrame: int = 0

var frames: Array

func _ready() -> void:
	frames.append($VBoxContainer/Frames/Frame1)

func update_texture(imgTexture: ImageTexture):
	canvas.update_texture(imgTexture)

func _on_frame_changed(num: int) -> void:
	frames[currentFrame].pressed = 0
	canvas.change_frame(num)
	currentFrame = num
	
func new_frame() -> void:
	var newFrame = emptyFrame.instance()
	newFrame.frameNumber = frames.size()
	frames.append(newFrame)
	newFrame.connect("frame_changed", self,"_on_frame_changed")
	frameBox.add_child(newFrame)
	canvas.new_frame()
