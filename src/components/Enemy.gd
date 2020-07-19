extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_RigidBody2D_body_entered(body: Node) -> void:
	if (body.is_in_group("bullet") || body.is_in_group("player")):
		self.queue_free();
	pass # Replace with function body.
