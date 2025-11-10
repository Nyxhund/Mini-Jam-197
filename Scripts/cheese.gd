extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


const max_frames = 6
var current_frame = 0
var delta_anim = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	delta_anim += delta
	
	if delta_anim > 0.1:
		
		$Idle.set_frame(current_frame)
		current_frame += 1
		current_frame = current_frame % max_frames
		delta_anim = 0
