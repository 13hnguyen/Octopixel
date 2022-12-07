extends Control

var textureCanvas: DefaultCanvas
var animationCanvas: DefaultCanvas

var currentToolLeft: Dictionary = {}
var currentToolRight: Dictionary = {}

func _ready() -> void:
	currentToolLeft = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
	currentToolRight = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
	

func update_texture_canvas(canva: DefaultCanvas):
	textureCanvas = canva
	$TextureSelectonTool.canvas = canva

func update_animation_canvas(canva: DefaultCanvas):
	animationCanvas = canva
	$SelectionTool.canvas = canva
	$DuplicateTool.canvas = canva
	$TextureSelectonTool.targetCanvas = canva

func _change_tool(button_pressed: bool) -> void:
	if !currentToolLeft.empty():
		currentToolLeft["tool"].isActive = false
		currentToolLeft["button"].pressed = false
	
	if !currentToolRight.empty():
		currentToolRight["tool"].isActive = false
		currentToolRight["button"].pressed = false
	
	currentToolLeft = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
	currentToolRight = {
		"tool": $TextureSelectonTool,
		"button": $VBoxContainer/TextureSelectionButton
	}
