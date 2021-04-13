# Allows the user to move the parent object by dragging it with the mouse.
class_name DragArea2D

extends Area2D


# Called when parent starts following the mouse.
signal picked_up
# Called when parent stops following the mouse.
signal put_down


# If true, the dragged parent will move so that the mouse is at (0, 0).
# If false, the dragged parent will move so that the mouse retains the same relative position.
export (bool) var grab_centered := true
# Prevent dragging from moving parent along the x-axis
export (bool) var restrict_x := false
# Prevent dragging from moving parent along the y-axis
export (bool) var restrict_y := false

# Whether the object is currently being dragged
var dragging := false
# The initial mouse position relative to the dragged object
var drag_offset := Vector2()


# If `dragging` is true, moves the parent to the mouse position
func _process(delta):
	if dragging:
		var target = get_viewport().get_mouse_position() - drag_offset
		if not restrict_x:
			get_parent().position.x = target.x
		if not restrict_y:
			get_parent().position.y = target.y


# If the user clicks the drag area, starts dragging. If the user unclicks, stops dragging.
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed and not dragging and _is_in_drag_area(event.position):
			pick_up()
		elif not event.pressed and dragging:
			put_down()


# Checks if `point` is within the drag area.
func _is_in_drag_area(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(point, 32, [], 2147483647, false, true)
	for result in results:
		var collider = result["collider"]
		if collider == self:
			return true
	return false


# Makes the parent start following the mouse.
func pick_up() -> void:
	dragging = true
	if grab_centered:
		drag_offset = Vector2()
	else:
		drag_offset = get_viewport().get_mouse_position() - self.global_position
	emit_signal("picked_up")


# Makes the parent stop following the mouse.
func put_down() -> void:
	dragging = false
	emit_signal("put_down")