extends Control

signal frame_changed(texture)

onready var canvas: DefaultCanvas = $"%TextureCanvas"
onready var frameBox: HBoxContainer = $VBoxContainer/Frames

onready var openDialog: FileDialog = $OpenFileDialog
onready var saveDialog: FileDialog = $SaveFileDialog

onready var emptyFrame: PackedScene = preload("res://widgets/Frame.tscn")

var currentFrame: int = 0

var frames: Array

func _ready() -> void:
	canvas.new_frame()
	_create_Frame_check()

func update_texture(imgTexture: ImageTexture):
	canvas.update_texture(imgTexture)


func _on_frame_changed(num: int) -> void:
	frames[currentFrame].pressed = 0
	frames[num].pressed = 1
	canvas.change_frame(num)
	currentFrame = num

func _create_Frame_check() -> void:
	var newFrame = emptyFrame.instance()
	
	newFrame.frameNumber = frames.size()
	frames.append(newFrame)
	newFrame.connect("frame_changed", self,"_on_frame_changed")
	frameBox.add_child(newFrame)
	
	newFrame._on_CheckBox_pressed()

func _on_New_Frame_pressed() -> void:
	
	canvas.new_frame()
	_create_Frame_check()
	

func _on_Open_pressed() -> void:
	openDialog.popup()


func _on_Save_pressed() -> void:
	saveDialog.popup()


func _on_OpenFileDialog_files_selected(paths: PoolStringArray) -> void:
	for path in paths:
		canvas.load_frame(path)
		_create_Frame_check()


func _on_SaveFileDialog_files_selected(paths: PoolStringArray) -> void:
	pass # Replace with function body.


func _on_TextureCanvas_frame_changed() -> void:
	emit_signal("frame_change", canvas.imageTexture)

