extends GutTest

# Note: its somewhat concerning how much setup this needs, but I also already knew
# that AttachHitboxComponent is coupled to multiple things so its not too surprising
func test_on_area_entered():
	var attack = Attack.new()
	attack.damage = 0.5

	var attack_hitbox = AttackHitboxComponent.new()

	var projectile = Projectile.new()
	projectile.attack = attack
	projectile.add_child(attack_hitbox)

	var health = HealthComponent.new()
	health.MAX_HEALTH = 1.0
	health.health = 1.0

	var hitbox = HitboxComponent.new()
	hitbox.health_component = health

	attack_hitbox._on_area_entered(hitbox)

	assert_eq(health.health, 0.5)

	hitbox.free()
	projectile.free()
	health.free()
