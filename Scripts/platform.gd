extends AnimatableBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1.0
var buttonPressed = false
var prevPosition = Vector2(0.0, 0.0)
@export var vertical_movement: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Start")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("ui_accept"):
	#	move_and_collide(Vector2.UP * 5.0)

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		buttonPressed = false
		#print("UN Pressed Button")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseMotion:
		if buttonPressed:
			var mult = 0
			if vertical_movement:
				mult = 1
				
			move_and_collide(Vector2((1 - mult) * (event.position.x - prevPosition.x), mult * (event.position.y - prevPosition.y)))
			prevPosition = event.position
	
	if event.is_action_pressed("left_click"):
		#print("Pressed Button")
		prevPosition = event.position
		buttonPressed = true
