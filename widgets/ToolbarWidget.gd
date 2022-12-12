extends Control

var textureCanvas: DefaultCanvas
var animationCanvas: DefaultCanvas

var currentToolLeft: Dictionary = {}
var currentToolRight: Dictionary = {}

onready var colorPicker: ColorPicker = $ColorPicker
onready var sharedTools: Array = $ToolShared.get_children()
onready var textureTools: Array = $ToolTexture.get_children()
onready var animationTools: Array = $ToolAnimation.get_children()

func _ready() -> void:
	_change_tool(true, true, true, $ToolShared/TextureSelectonTool, $SharedTools/VBoxContainer/TextureSelectionButton)
	
	$ToolTexture/PaintTool.colorPicker = colorPicker
	
	colorPicker.get_child(4).get_child(0).hide()
	colorPicker.get_child(4).get_child(1).hide()
	colorPicker.get_child(4).get_child(2).hide()
	

func update_texture_canvas(canva: DefaultCanvas):
	textureCanvas = canva
	
	for child in textureTools:
		child.canvas = canva
	for child in sharedTools:
		child.canvas = canva

func update_animation_canvas(canva: DefaultCanvas):
	animationCanvas = canva
	
	for child in animationTools:
		child.canvas = canva
	for child in sharedTools:
		child.targetCanvas = canva


func _clearLeft() -> void:
	var isToolUnique:bool = true
	if !currentToolLeft.empty():
		isToolUnique = currentToolLeft["tool"].isUnique
		currentToolLeft["tool"].unselect()
		currentToolLeft["button"].pressed = false
		currentToolLeft = {}
	
	if isToolUnique:
		if !currentToolRight.empty():
			currentToolRight["tool"].unselect()
			currentToolRight["button"].pressed = false
			currentToolRight = {}
			

func _clearRight() -> void:
	var isToolUnique:bool = true
	if !currentToolRight.empty():
		isToolUnique = currentToolRight["tool"].isUnique
		currentToolRight["tool"].unselect()
		currentToolRight["button"].pressed = false
		currentToolRight = {}
	
	if isToolUnique:
		if !currentToolLeft.empty():
			currentToolLeft["tool"].unselect()
			currentToolLeft["button"].pressed = false
			currentToolLeft = {}

func _change_tool(button_pressed: bool, leftHand: bool, isUnique: bool, toolObject: DefaultTool, button: Button) -> void:
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
	
	if isUnique:
		
		currentToolLeft = currentTool
		currentToolRight = currentTool
		return
	
	if leftHand:
		currentToolLeft = currentTool
		return
	
	currentToolRight = currentTool
	return
