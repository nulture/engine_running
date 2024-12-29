extends CharacterBody2D

@export var walk_speed := 120.0
@export var climb_speed := 120.0


var _detected_ladder : Area2D
var is_on_ladder : bool :
	get: return _detected_ladder != null

var _wants_to_climb : bool
var is_climbing : bool :
	get: return _wants_to_climb and is_on_ladder


func _physics_process(delta: float) -> void:

	var climb_direction := Input.get_axis("move_up", "move_down")
	var walk_direction := Input.get_axis("move_left", "move_right")

	if walk_direction:
		_wants_to_climb = false

	if is_on_ladder and climb_direction:
		velocity = Vector2.DOWN.rotated(_detected_ladder.global_rotation) * climb_direction * climb_speed
		_wants_to_climb = true
	elif is_climbing:
		velocity = Vector2.ZERO
	else:
		if walk_direction:
			velocity.x = walk_direction * walk_speed
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)

		if not is_on_floor():
			velocity += get_gravity() * delta
	

	move_and_slide()


func _on_ladder_sensor_area_entered(area:Area2D) -> void:
	_detected_ladder = area


func _on_ladder_sensor_area_exited(area:Area2D) -> void:
	if _detected_ladder == area:
		_detected_ladder = null
		_wants_to_climb = false

