extends Control

"""
Default Canvas

Displays the Image. Allows zooming in and out
"""

class_name DefaultCanvas

#signals
signal frame_changed

# components
onready var canvas: TextureRect = $"%Canvas"
onready var background: TextureRect = $Background
onready var camera: Camera2D = $Camera2D

onready var selection: TextureRect = $Selection

# Image
var image: Image
var imageTexture: ImageTexture

var frames: Array
var currentFrame: int = 0

var selectionImage: Image
var selectionTexture: ImageTexture

# variables
var zoomFactor: int = 100

func _ready() -> void:
	initialize_texture()
	update()
	
	update_selection_size()
	
	selectionImage = Image.new()
	selectionImage.copy_from(image)
	
	selectionTexture = ImageTexture.new()
	#$SelectionWindow.setCanvas(self)

func zoom(factor: int) -> void:
	if factor != -1:
		zoomFactor = clamp(factor, Global.ZOOM_MIN, Global.ZOOM_MAX)
	camera.zoom = Vector2.ONE * (zoomFactor/100)

func initialize_texture() -> void:
	imageTexture = ImageTexture.new()
	load_image("")


func load_image(path: String) -> void:
	if path:
		imageTexture.load(path)
		image = imageTexture.get_data()
		update()
	else:
		image = canvas.texture.get_data()
		imageTexture.create_from_image(image,3)

func load_frame(path:String) -> void:
	var imgTexture = ImageTexture.new()
	imgTexture.load(path)
	var img = imgTexture.get_data()
	frames.append(img)

func _draw() -> void:
	update_image()

func update_image() -> void:
	imageTexture.create_from_image(image,3)
	canvas.set_texture(imageTexture)
	emit_signal("frame_changed")

func get_size() -> Vector2:
	return image.get_size()

func mouse_coordinates() -> Vector2:
	var coord = canvas.get_local_mouse_position()
	var canvasSize = canvas.rect_size
	var imageSize = image.get_size()
	
	
	if canvasSize.x < canvasSize.y:
		coord = imageSize.x*coord/canvasSize.x
	else:
		coord = imageSize.y*coord/canvasSize.y
	return coord.floor()

func new_frame() -> void:
	var img = Image.new()
	img.copy_from(image)
	frames.append(img)

func change_frame(index: int) -> void:
	image = frames[index]
	currentFrame = index
	update_selection_size()
	update_image()
	update()

func update_selection_size():
	var tempImage = Image.new()
	tempImage.copy_from(image)
	tempImage.fill(Color(1,1,1,1))
	
	var tempTexture = ImageTexture.new()
	tempTexture.create_from_image(tempImage,3)
	
	selection.set_texture(tempTexture)
	
func change_selection(newRect: Rect2) -> void:
	selectionImage.copy_from(image)
	selectionImage.fill(Color(0,0,0,0))
	selectionImage.fill_rect(newRect, Color(1,1,1,1))
	
	selectionTexture.create_from_image(selectionImage,3)
	
	selection.get_material().set_shader_param("tex", selectionTexture)
	
