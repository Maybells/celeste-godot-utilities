extends Sprite


func _ready():
	$OverlapDetector2D.connect("overlap_changed", self, "_on_overlap_changed")


func _on_overlap_changed(from: Object, to: Object):
	if to:
		print("Overlapping " + to.name)
	else:
		print("No overlap")
