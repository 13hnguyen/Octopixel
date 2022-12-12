extends Control

signal frame_changed(texture)
signal frame_number_modified()

onready var canvas: DefaultCanvas = $"%AnimationCanvas"
onready var frameBox: HBoxContainer = $VBoxContainer/Frames

onready var openDialog: FileDialog = $OpenFileDialog
onready var saveDialog: FileDialog = $SaveFileDialog

onready var emptyFrame: PackedScene = preload("res://widgets/FrameVertical.tscn")

onready var zoom: Control = $Zoom

var currentFrame: int = 0

var frames: Array

func _ready() -> void:
	canvas.new_frame()
	_create_Frame_check()
	_on_AnimationWidget_item_rect_changed()
	zoom.camera = canvas.camera

func update_texture(imgTexture: ImageTexture):
	canvas.update_texture(imgTexture)


func _on_frame_changed(num: int) -> void:
	frames[currentFrame].setPressed(0)
	frames[num].setPressed(1)
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
	for path in paths:
		canvas.image.save_png(path)


func _on_AnimationWidget_item_rect_changed() -> void:
	$VBoxContainer/AnimationViewport/Viewport.size.y = rect_size.y - 150
	$VBoxContainer/AnimationViewport/Viewport.size.x = rect_size.x -20

func _on_SaveFileDialog_file_selected(path: String) -> void:
	canvas.image.save_png(path)


func _on_AnimationCanvas_frame_number_modified() -> void:
	emit_signal("frame_number_modified")

func clear(sizeVector: Vector2) -> void:
	canvas.image.create(sizeVector.x, sizeVector.y, false, Image.FORMAT_RGBA8)
	canvas.frames = []
	canvas.currentFrame = 0
	for frame in frames:
		frame.queue_free()
	frames = []
	currentFrame = 0
	canvas.new_frame()
	_create_Frame_check()
