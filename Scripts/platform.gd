extends AnimatableBody2D

var buttonPressed = false
var prevPosition = Vector2(0.0, 0.0)
@export var vertical_movement: bool

var spawn_point = null
var recording = true
var commit = false
var placement = []
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_point = position

func reset() -> void:
	set_position(spawn_point)
	recording = not commit
	index = 0
	if recording:
		placement = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recording:
		placement.append([position, buttonPressed])
	else:
		set_position(placement[index][0])
		buttonPressed = placement[index][1]
		index += 1
		if index == len(placement):
			index -= 1

func _input(event: InputEvent) -> void:	
	if event.is_action_released("left_click"):
		buttonPressed = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseMotion:
		if buttonPressed:
			var mult = 0
			if vertical_movement:
				mult = 1

			if recording:
				move_and_collide(Vector2((1 - mult) * (event.position.x - prevPosition.x), mult * (event.position.y - prevPosition.y)))
				prevPosition = event.position
	
	if event.is_action_pressed("left_click"):
		commit = true
		prevPosition = event.position
		buttonPressed = true
