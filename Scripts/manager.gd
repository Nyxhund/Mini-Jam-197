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
@export var dialog_path: String
@export var current_scene: String

var cheese_out_of_vision = []
var cheese_spawns_list = []

var currentDialog = 0
var dialog = []

var next_path = ""
var platform_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open(dialog_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		dialog = json.data.dialog
		next_path = json.data.next_level
		platform_speed = json.data.speed
	else:
		print("ERROR WHILE PARSING DIALOG")
	
	tutorial.set_visible(true)
	mouse_list[0].move_to_spawn()
	
	for cheese in cheese_list:
		cheese_out_of_vision.append(cheese.position)
		
	for platform in platform_list:
		platform.platform_speed = platform_speed
	
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
		get_tree().change_scene_to_file(next_path)
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
	
	#cumul += delta
	#if cumul > 3.0:
		#print()
		#print("Mouse 1 ", mouse_list[0].foundCheese)
		#print("Mouse 2 ", mouse_list[1].foundCheese)
		#print("Mouse 3 ", mouse_list[2].foundCheese)
		#print()
		#cumul = 0
		
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
	get_tree().change_scene_to_file(current_scene)
