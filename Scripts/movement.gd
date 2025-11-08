extends CharacterBody2D

@export var going_right = true
@export var spawn_point: Node2D

const SPEED = 150.0
var direction = 1.0
var foundCheese = true
var bufferPlace = null

func _ready() -> void:
	bufferPlace = position

func reset():
	direction = 1.0 if going_right else -1.0
	foundCheese = false
	set_position(spawn_point.position)
	velocity = Vector2(0.0, 0.0)
	move_and_slide()
	$CollisionShape2D.set_disabled(false)
	
func move_to_spawn():
	set_position(spawn_point.position)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if foundCheese:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	else:
		var collision = get_last_slide_collision()

		if is_on_wall():
			direction = -1 * direction

		# Move in the current direction
		velocity.x = direction * SPEED
		
		# In the case of a collision...
		if collision:
			var node = collision.get_collider()

			# with a movabler platform object, check if it is moving
			if node and node is AnimatableBody2D and node.buttonPressed:
				velocity = Vector2(0, 0)
			
			if node and node.has_meta("cheese") and node.get_meta("cheese"):
				foundCheese = true
				node.set_meta("cheese", false)
				node.get_node("CollisionShape2D").set_disabled(true)
				$CollisionShape2D.set_disabled(true)
	move_and_slide()
