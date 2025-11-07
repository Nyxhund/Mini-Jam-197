extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var direction = 1.0;

func _physics_process(delta: float) -> void:
	# Add the gravity.
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
	move_and_slide()
