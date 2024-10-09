extends CanvasLayer

@onready var bbs = $VBoxContainer/BBs
@onready var mode = $VBoxContainer/Mode
@onready var bb_mass = $VBoxContainer/BBMass
@onready var hop_up = $VBoxContainer/HopUp


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


func update_stat_text():
	update_bbs()
	update_mode()
	update_bb_mass()
	update_hop_up()
