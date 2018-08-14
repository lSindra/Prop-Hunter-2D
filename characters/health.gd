extends Node

signal health_changed
signal health_depleted

var health = 0
export(int) var max_health = 9

var status = null
enum STATUSES { NONE, INVINCIBLE }


func _ready():
	health = max_health

func take_damage(amount):
	if status == INVINCIBLE:
		return
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
#	print("%s got hit and took %s damage. Health: %s/%s" % [get_name(), amount, health, max_health])


func heal(amount):
	health += amount
	health = max(health, max_health)
	emit_signal("health_changed", health)
#	print("%s got healed by %s points. Health: %s/%s" % [get_name(), amount, health, max_health])
