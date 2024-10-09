extends Gun

func _ready():
	model = 'pistol'
	magazine_type = 'pistol'
	magazine = magwell.get_child(0)
	magazine.grab_magazine()
	spring_force = 1.49
	rate_of_fire = 3.0
	can_full_auto = false
	$ShotDelay.wait_time = 1/rate_of_fire
	hop_up = 0.004
