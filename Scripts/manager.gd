extends Node2D

var stage = 1
var timing = 0

@export var mouse_list: Array[Node2D]
@export var platform_list: Array[AnimatableBody2D]
@export var label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_list[0].reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timing += delta
	
	if timing > 2.5:
		label.text = ""
	
	if mouse_list.all(func(m): return m.foundCheese):
		label.text = "All done !\nNext round !"
		timing = 0
		
		stage += 1
		if stage > 3:
			label.text = "\nYou finished the current level !!"
			return
		
		for i in range(stage):
			mouse_list[i].reset()
			
		for platform in platform_list:
			platform.reset()
