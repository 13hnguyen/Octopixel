extends Control

var textureCanvas: DefaultCanvas
var animationCanvas: DefaultCanvas

var currentToolLeft: Dictionary = {}
var currentToolRight: Dictionary = {}

onready var colorPicker: ColorPicker = $ColorPicker


func _ready() -> void:
	currentToolLeft = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
	currentToolRight = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
	
	$PaintTool.colorPicker = colorPicker
	
	

func update_texture_canvas(canva: DefaultCanvas):
	textureCanvas = canva
	$TextureSelectonTool.canvas = canva
	$PaintTool.canvas = canva

func update_animation_canvas(canva: DefaultCanvas):
	animationCanvas = canva
	$SelectionTool.canvas = canva
	$DuplicateTool.canvas = canva
	$TextureSelectonTool.targetCanvas = canva


func _clearLeft() -> void:
	if !currentToolLeft.empty():
		currentToolLeft["tool"].unselect()
		currentToolLeft["button"].pressed = false

func _clearRight() -> void:
	if !currentToolRight.empty():
		currentToolRight["tool"].unselect()
		currentToolRight["button"].pressed = false

func _change_tool(button_pressed: bool, leftHand: bool, isUnique: bool, toolObject: DefaultTool, button: Button) -> void:
	print("_change_tool")
	if isUnique:
		_clearLeft()
		_clearRight()
	elif leftHand:
		_clearLeft()
	else:
		_clearRight()

	if !button_pressed:
		return
	
	toolObject.select()
	button.pressed = true
	
	var currentTool = {
		"tool": toolObject,
		"button": button
	}
	print(toolObject)
	
	if isUnique:
		
		currentToolLeft = currentTool
		currentToolRight = currentTool
		return
	
	if leftHand:
		currentToolLeft = currentTool
		return
	
	currentToolRight = currentTool
	return
