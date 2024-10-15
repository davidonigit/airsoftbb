extends CanvasLayer

@onready var bbs = $MainHUD/VBoxContainer/BBs
@onready var mode = $MainHUD/VBoxContainer/Mode
@onready var bb_mass = $MainHUD/VBoxContainer/BBMass
@onready var hop_up = $MainHUD/VBoxContainer/HopUp
@onready var balloons_popped = $MainHUD/VBoxContainer2/BalloonsPopped


func _ready():
	Globals.connect("stat_change", update_stat_text)


func update_bbs():
	bbs.text = "BBs: "+str(Globals.bbs_amount)+"/"+str(Globals.bbs_capacity)


func update_mode():
	if Globals.full_auto:
		mode.text = "Mode: FullAuto"
	else:
		mode.text = "Mode: SingleShot"


func update_bb_mass():
	bb_mass.text =  "Mass: "+str(Globals.bb_mass*100)+"g"


func update_hop_up():
	hop_up.text = "Hop Up: "+str(Globals.hop_up)

func update_balloons():
	balloons_popped.text = "Balloons Popped: "+str(Globals.balloons_popped)+"/"+str(Globals.balloons_total)

func update_stat_text():
	update_bbs()
	update_mode()
	update_bb_mass()
	update_hop_up()
	update_balloons()

func circuit_finished():
	$MainHUD.hide()
	$FinishPanel/VBoxContainer/BalloonsPopped.text = balloons_popped.text
	$FinishPanel.show()


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
	$MainHUD.show()
	$FinishPanel.hide()
	Globals.balloons_popped = 0
