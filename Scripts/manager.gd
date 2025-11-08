extends Node2D

var stage = 0
var playing = false

@export var mouse_list: Array[Node2D]
@export var platform_list: Array[AnimatableBody2D]
@export var cheese_list: Array[Node2D]
@export var tutorial: CanvasItem
@export var label : Label

var currentDialog = 0
var dialog = [
	["Hello there !",
	"Nice to meet you fellow mouse",
	"I need your help !\nA time fracture occured, because...",
	"You don't need to know why yet...\nBut my friends have been scattered in time !",
	"And we lost all our cheese...\nCould you help us out ?",
	"You just need to control the platform at the right time.\nTry getting that top piece"],
	
	["Great !"],
	[
		"VEry impressive !"
	],
	[
		"All done !\nYou are truly a genius !"
	]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial.set_visible(true)
	mouse_list[0].move_to_spawn()
	start_stage()

func start_stage():
	if stage + 1 == len(dialog) and currentDialog == len(dialog[stage]):
		return

	if stage < len(dialog) and currentDialog < len(dialog[stage]):
		label.text = dialog[stage][currentDialog]
		currentDialog += 1
		return

	currentDialog = 0
	
	playing = true
	tutorial.set_visible(false)
	
	for i in range(stage + 1):
		mouse_list[i].reset()
			
	for platform in platform_list:
		platform.reset()
		
	for cheese in cheese_list:
		cheese.set_meta("cheese", true)
		cheese.get_node("CollisionShape2D").set_disabled(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if stage >= 3:
		return
	
	if playing and mouse_list.all(func(m): return m.foundCheese):
		playing = false
		stage += 1
		
		if stage >= 3:
			tutorial.set_visible(true)
			start_stage()
			return

		for i in range(stage + 1):
			mouse_list[i].move_to_spawn()
			mouse_list[i].foundCheese = true

		start_stage()
		tutorial.set_visible(true)

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
