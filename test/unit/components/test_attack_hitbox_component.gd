extends GutTest

# NOTE: its somewhat concerning how much setup this needs, but I also already knew
# that AttachHitboxComponent is coupled to multiple things so its not too surprising
func test_on_area_entered():
	var attack = Attack.new()

	var attack_hitbox = AttackHitboxComponent.new()

	var projectile = Projectile.new()
	projectile.attack = attack
	projectile.add_child(attack_hitbox)

	var hitbox = double(HitboxComponent).new()

	attack_hitbox._on_area_entered(hitbox)

	assert_called(hitbox, "take_damage")

	projectile.free()
