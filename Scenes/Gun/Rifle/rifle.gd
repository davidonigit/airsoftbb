extends Gun


func _ready():
	model = 'rifle'
	magazine_type = 'rifle'
	magazine = magwell.get_child(0)
	magazine.grab_magazine()
	spring_force = 3.0
	rate_of_fire = 8.0
	can_full_auto = true
	full_auto = true
	$ShotDelay.wait_time = 1/rate_of_fire
	hop_up = 0.004
