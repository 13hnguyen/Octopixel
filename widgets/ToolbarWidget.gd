extends Control

var textureCanvas: DefaultCanvas
var animationCanvas: DefaultCanvas

func update_texture_canvas(canva: DefaultCanvas):
	textureCanvas = canva
	$TextureSelectonTool.canvas = canva

func update_animation_canvas(canva: DefaultCanvas):
	animationCanvas = canva
	$SelectionTool.canvas = canva
	$DuplicateTool.canvas = canva
	$TextureSelectonTool.targetCanvas = canva
