extends Node

signal stat_change

var bbs_amount = 0:
	set(value):
		bbs_amount = value
		stat_change.emit()

var bbs_capacity = 0:
	set(value):
		bbs_capacity = value
		stat_change.emit()

var full_auto = true:
	set(value):
		full_auto = value
		stat_change.emit()

var bb_mass = 0:
	set(value):
		bb_mass = value
		stat_change.emit()

var hop_up = 0:
	set(value):
		hop_up = value
		stat_change.emit()

var balloons_popped = 0:
	set(value):
		balloons_popped = value
		stat_change.emit()

var balloons_total = 0:
	set(value):
		balloons_total = value
		stat_change.emit()
