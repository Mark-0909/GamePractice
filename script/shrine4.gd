extends Area2D

@onready var wood: CharacterBody2D = $"../../woods/wood4"
@onready var game_manager: Node = %gameManager


var is_activated: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_activated:
		if body.get("souls") >= 5:
			print("Enough souls")
			is_activated = true

			if body.has_method("OfferSouls"):
				body.OfferSouls(true)

			$AnimatedSprite2D.play("shine")

			var wood_sprite := wood.get_node_or_null("AnimatedSprite2D")
			if wood_sprite:
				wood_sprite.play("open")

			await get_tree().create_timer(0.5).timeout
			wood.queue_free()
			body.set("souls", 0)

			# Wait for each soul to disperse
			for soul in get_tree().get_nodes_in_group("Soul"):
				if soul.has_method("Disperse"):
					await soul.Disperse()

			if body.has_method("OfferSouls"):
				body.OfferSouls(false)
				game_manager.set("checkpoint", 4)
				
				print("checkpoint: ", game_manager.get("checkpoint"))
				$"../../CanvasLayer/floor".text = "FLOOR 4"
			
		else:
			print("Not enough souls:", body.get("souls"))
