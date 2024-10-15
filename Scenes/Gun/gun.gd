extends RigidBody2D
class_name Gun

@onready var magwell = $Magwell

var model:String
var magazine_type:String
var magazine:Magazine
var spring_force:float
var rate_of_fire:float
var hop_up:float = 0.004
var can_full_auto:bool
var full_auto:bool
var direction:Vector2
var shot_delay:bool

var collected:bool = false

func _process(delta):
	if collected:
		look_at(get_global_mouse_position())
		position = Vector2.ZERO
		direction = (get_global_mouse_position()-global_position).normalized()
		if direction.x < 0:
			scale = Vector2(1,-1)
		else:
			scale = Vector2(1,1)


func _input(event):
	if collected:
		if event.is_action_pressed("toggle_full_auto") and can_full_auto:
			full_auto = !full_auto
			Globals.full_auto = full_auto


func get_shoot_position():
	return $ShootPoint.global_position


func get_shoot_direction():
	return direction


func grab_gun():
	collected = true
	Globals.bbs_capacity = magazine.capacity
	Globals.bbs_amount = magazine.current_bb_number
	Globals.bb_mass = magazine.current_bb_mass
	Globals.full_auto = full_auto
	Globals.hop_up = hop_up
	$GrabArea.set_collision_layer_value(3, false)


func drop_gun():
	collected = false
	$GrabArea.set_collision_layer_value(3, true)
	linear_velocity = Vector2.ZERO


func can_shoot():
	if magazine != null and magazine.current_bb_number > 0 and !shot_delay:
		return true
	else:
		return false


func shoot():
	magazine.current_bb_number -= 1
	Globals.bbs_amount = magazine.current_bb_number
	shot_delay = true
	$ShotDelay.start()


func change_hop_up(value):
	hop_up = clampf(hop_up+value, 0.0, 0.01)
	Globals.hop_up = hop_up


func _on_shot_delay_timeout():
	shot_delay = false


func eject_magazine():
	magwell.remove_child(magazine)
	get_parent().get_parent().get_parent().add_child(magazine)
	magazine.global_position = get_parent().global_position
	magazine.drop_magazine()


func insert_magazine(new_mag):
	magwell.add_child(new_mag)
	new_mag.global_position = magwell.global_position
	magazine = new_mag
	magazine.grab_magazine()
