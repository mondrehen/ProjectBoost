extends AnimatableBody3D
@export var duration:float = 3.0
@export var destination:Vector3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"global_position",global_position + destination,duration)
	tween.tween_property(self,"global_position",global_position,duration)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
