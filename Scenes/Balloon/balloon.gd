extends RigidBody2D
class_name Balloon

func pop():
	Globals.balloons_popped += 1
	queue_free()
