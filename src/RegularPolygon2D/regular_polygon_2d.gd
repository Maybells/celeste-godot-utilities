tool


class_name RegularPolygon2D

extends Polygon2D


export (int, 3, 50) var sides = 4 setget _sides_set
export (float) var radius = 1 setget _radius_set
var points := PoolVector2Array()


func _ready():
	_generate_points()


func _draw():
	draw_colored_polygon(points, color, uv, texture)


func _generate_points():
	points = PoolVector2Array()
	var arc = (2 * PI) / sides
	var tilt = PI / 2
	for i in range(sides):
		var point = polar2cartesian(radius, (arc * i) - tilt)
		points.append(point)
	update()


func _sides_set(val):
	sides = val
	_generate_points()


func _radius_set(val):
	radius = val
	_generate_points()
