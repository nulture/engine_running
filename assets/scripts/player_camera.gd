extends Camera2D

const ZOOM_SETTINGS : PackedFloat64Array = [ 1.0, 4.0 ]

@export var zoom_speed : float = 10.0

var _zoom_scale : float
var _target_zoom_scale : int
var target_zoom_scale : int :
	get: return _target_zoom_scale
	set(value):
		value = clampi(value, 0, ZOOM_SETTINGS.size() - 1)
		if _target_zoom_scale == value: return
		_target_zoom_scale = value


func _init() -> void:
	_target_zoom_scale = ZOOM_SETTINGS.find(self.zoom.x)


func _process(delta: float) -> void:
	_zoom_scale = lerp(_zoom_scale, ZOOM_SETTINGS[target_zoom_scale], delta * zoom_speed)
	self.zoom = Vector2.ONE * _zoom_scale


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_cycle"):
		target_zoom_scale = wrapi(target_zoom_scale + 1, 0, ZOOM_SETTINGS.size())
	elif event.is_action_pressed("zoom_in"):
		target_zoom_scale += 1
	elif event.is_action_pressed("zoom_out"):
		target_zoom_scale -= 1