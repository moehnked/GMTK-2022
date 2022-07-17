extends Node2D

signal emit_roll_clicked()

enum State {NULL, ROLL, Q}

var state = State.NULL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enable_roll():
	$AnimationPlayer.play("null-to-roll")
	enable_pressable()

func shut_display():
	$AnimationPlayer.play("to-null")

func roll():
	$AnimationPlayer.play("roll-to-null")

func enable_pressable():
	$Button.visible = true
	state = State.ROLL

func _on_Button_pressed():
	match state:
		State.ROLL:
			emit_signal("emit_roll_clicked")
			roll()
			$Button.visible = false
	pass # Replace with function body.
