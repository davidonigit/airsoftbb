extends Area2D

signal circuit_finished

func _on_body_entered(body):
	if body is Player:
		Hud.circuit_finished()
