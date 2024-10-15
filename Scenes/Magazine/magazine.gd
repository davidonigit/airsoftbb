extends Area2D
class_name Magazine

var type:String
var capacity:int
var current_bb_number:int
var current_bb_mass:float


func grab_magazine():
	set_collision_layer_value(3, false)

func drop_magazine():
	set_collision_layer_value(3, true)
	if current_bb_number == 0:
		queue_free()
