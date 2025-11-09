extends Node2D

var stage = 0
var playing = false

@export var mouse_list: Array[Node2D]
@export var platform_list: Array[AnimatableBody2D]
@export var cheese_list: Array[Node2D]
@export var tutorial: CanvasItem
@export var label : Label
@export var cheese_spawns_one: Array[Node2D]
@export var cheese_spawns_two: Array[Node2D]
@export var cheese_spawns_three: Array[Node2D]

var cheese_out_of_vision = []
var cheese_spawns_list = []

var currentDialog = 0
var dialog = [
	[
		"Hello there !",
		"Nice to meet you,\n fellow mouse",
		"I need your help !\nA time fracture occured,\nbecause...",
		"Well, you don't need to know yet...\nBut my friends have been scattered in time !",
		"And we lost all our cheese...\nCould you help us out ?",
		"You just need to control the platform at the right time.\nTry getting that top piece",
		"You can move blue blocks vertically. Show me your talents !"
	],
	
	[
		"Great !",
		"But wait ... Another friend of mine appeared ... And the first one came back",
		"I think this is a new kind of anomaly ...\nWhat happens now",
	],
	[
		"Interesting ... you did not move that block this time, right ?",
		"It seems your actions on the timeline we were on a second ago carried out to this one ...",
		"And now yet another timeline has been created ... Try getting that last piece of cheese now !",
		"You can move yellow blocks horizontally ... Give it a try !"
	],
	[
		"All done!\nYou are truly a genius !"
	]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial.set_visible(true)
	mouse_list[0].move_to_spawn()
	
	for cheese in cheese_list:
		cheese_out_of_vision.append(cheese.position)
	
	cheese_spawns_list.append(cheese_spawns_one)
	cheese_spawns_list.append(cheese_spawns_two)
	cheese_spawns_list.append(cheese_spawns_three)

	var i = 0
	for spawn in cheese_spawns_one:
		cheese_list[i].set_position(spawn.position)
		i += 1
	
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
	
	print("Setting stage ", stage)
	for i in range(stage + 1):
		mouse_list[i].reset()
			
	for platform in platform_list:
		platform.reset()

var cumul = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if stage >= 3:
		return
	
	cumul += delta
	if cumul > 3.0:
		print()
		print("Mouse 1 ", mouse_list[0].foundCheese)
		print("Mouse 2 ", mouse_list[1].foundCheese)
		print("Mouse 3 ", mouse_list[2].foundCheese)
		print()
		cumul = 0
		
	if playing and mouse_list.all(func(m): return m.foundCheese):
		print("all the cheese was found")
		playing = false
		stage += 1
		
		if stage >= 3:
			tutorial.set_visible(true)
			start_stage()
			return

		for i in range(stage + 1):
			mouse_list[i].move_to_spawn()
			mouse_list[i].foundCheese = true
			
		var ite = 0
		for cheese in cheese_list:
				
			cheese.set_meta("cheese", true)
			cheese.get_node("CollisionShape2D").set_disabled(false)

			if ite < len(cheese_spawns_list[stage]):
				print("Cheese ", ite, " has a spawn point")
				cheese.set_position(cheese_spawns_list[stage][ite].position)
			else:
				print("Cheese ", ite, " is benched")
				cheese.set_position(cheese_out_of_vision[ite])
				
			ite += 1

		start_stage()
		tutorial.set_visible(true)

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
