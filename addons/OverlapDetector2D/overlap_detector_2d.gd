# Finds an object at a point.
class_name OverlapDetector2D

extends Node2D


# Called when current overlapping object is different from previous.
signal overlap_changed(from, to)


# Which groups the detector can interact with
export (PoolStringArray) var detection_groups: PoolStringArray
# If true, calculates overlap every frame. If false, calculates only when moving.
export (bool) var continuous_detection := false

# The most recent overlapping object
var current_overlap: Object
# Position of point last frame
var last_position: Vector2
# Objects that will be ignored
var exceptions := Array()


# If `continuous_detection` is true or `position` has changed, recalculate the overlap.
func _physics_process(delta):
	if continuous_detection or global_position != last_position:
		last_position = global_position
		_overlap_update()


# Finds the overlapping object and sends out a signal if different from when last checked.
func _overlap_update() -> void:
	var new_overlap = _get_overlap()
	if new_overlap != current_overlap:
		emit_signal("overlap_changed", current_overlap, new_overlap)
		current_overlap = new_overlap


# Finds the overlapping object.
func _get_overlap() -> Object:
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(global_position, 16, exceptions, 2147483647, true, true)
	
	if results.empty():
		return null
	
	for result in results:
		var overlap = result["collider"]
		for group in detection_groups:
			if overlap.is_in_group(group):
				return overlap
		add_exception(overlap)
		
	return _get_overlap()


# Adds an exception that will no longer be detected.
func add_exception(exception: Object) -> void:
	exceptions.append(exception)


# Recalculates overlap.
func force_overlap_update() -> void:
	_overlap_update()


# Gets the most recent overlapping object.
func get_overlap() -> Object:
	return current_overlap
