extends CharacterBody2D
class_name Player

@onready var tip_label = $TipLabel
@onready var gun_bag = $GunBag
var gun
 
const SPEED = 500.0
const JUMP_VELOCITY = -550.0
var has_gun:bool = false

var item_to_grab = []

signal shoot_bb(pos, dir)


func _ready():
	gun = gun_bag.get_child(0)
	if gun != null:
		gun.grab_gun()
		has_gun = true
		tip_label.hide()
	Hud.update_stat_text()

func _physics_process(delta):
	if Input.is_action_just_pressed("grab_item") and !item_to_grab.is_empty():
		if item_to_grab[0] is Gun:
			grab_gun(item_to_grab[0])
		elif item_to_grab[0] is Magazine:
			if item_to_grab[0].type == gun.magazine_type:
				grab_magazine(item_to_grab[0])
			
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if has_gun:
		if gun.full_auto:
			if Input.is_action_pressed("shoot"):
				shoot()
		else:
			if Input.is_action_just_pressed("shoot"):
				shoot()
		if Input.is_action_just_pressed("hop_up_up"):
			gun.change_hop_up(0.001)
		if Input.is_action_just_pressed("hop_up_down"):
			gun.change_hop_up(-0.001)
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func shoot():
	if gun.can_shoot():
		gun.shoot()
		var pos = gun.get_shoot_position()
		var dir = gun.get_shoot_direction()
		var spring_force = gun.spring_force
		var bb_mass = gun.magazine.current_bb_mass
		var hop_up = gun.hop_up
		shoot_bb.emit(pos, dir, spring_force, bb_mass, hop_up)


func grab_gun(new_gun):
	if gun_bag.get_child_count() > 0:
		drop_gun()
	new_gun.get_parent().remove_child(new_gun)
	gun_bag.add_child(new_gun)
	new_gun.grab_gun()
	new_gun.magazine.grab_magazine()
	new_gun.position = Vector2.ZERO
	gun = new_gun
	has_gun = true


func drop_gun():
	var gun_pos = gun.global_position
	gun_bag.remove_child(gun)
	get_parent().add_child(gun)
	gun.drop_gun()
	gun.global_position = gun_pos
	gun = null
	has_gun = false


func grab_magazine(magazine):
	gun.eject_magazine()
	get_parent().remove_child(magazine)
	gun.insert_magazine(magazine)
	Globals.bbs_amount = magazine.current_bb_number
	Globals.bbs_capacity = magazine.capacity
	Globals.bb_mass = magazine.current_bb_mass


func _on_grab_area_area_entered(area):
	if area.get_parent() is Gun:
		item_to_grab.push_front(area.get_parent())
	if area is Magazine:
		item_to_grab.push_front(area)
	change_tip_label()


func _on_grab_area_area_exited(area):
	item_to_grab.pop_front()
	if item_to_grab.is_empty():
		tip_label.hide()
	else:
		change_tip_label()


func change_tip_label():
	if gun:
		if item_to_grab[0] is Gun:
			tip_label.text = 'Grab '+str(item_to_grab[0].model)
		elif item_to_grab[0] is Magazine:
			if item_to_grab[0].type == gun.magazine_type:
				tip_label.text = 'Grab '+str(item_to_grab[0].type)+' magazine'
			else:
				tip_label.text = str(item_to_grab[0].type)+' magazine'
		tip_label.show()
