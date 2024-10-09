extends Node2D

var bb_scene:PackedScene = load("res://Scenes/BB/bb.tscn")
@onready var bbs = $BBs
@onready var camera_2d = $Player/Camera2D

var bb_trajectories = []
var current_bb = null

func _process(delta):
	if current_bb != null:
		bb_trajectories.append(current_bb.global_position)
	queue_redraw()


func _draw():
	for i in range(bb_trajectories.size()-1):
		draw_line(bb_trajectories[i], bb_trajectories[i+1], Color(1, 0, 0), 2)


func _on_player_shoot_bb(pos, dir, spring_force, bb_mass, hop_up):
	var bb = bb_scene.instantiate() as RigidBody2D
	bb.position = pos
	bb.direction = dir
	bbs.add_child(bb)
	bb.connect("bb_collide", _on_bb_collide)
	bb.shoot_bb(spring_force, bb_mass, hop_up)
	
	current_bb = bb
	bb_trajectories.clear()


func _on_bb_collide(bb):
	if bb == current_bb:
		current_bb = null
	#$Camera2D.position.x = gun.position.x
