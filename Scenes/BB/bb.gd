extends RigidBody2D

#A velocidade é dada em px/s.
#Sem conversão, cada px representa 1 metro
#Convertendo para 50, cada 50px = 1 metro
#Para encontra os valores em metros, multiplicar as velocidades e dividir as distâncias
const PIXEL_TO_CM = 50

var is_shoot:bool = false
var pos_inicial
var pos_final
var first_vel = true
var direction:Vector2
var last_point:Vector2
var current_point:Vector2

var backspin_drag:float = 0.004

signal bb_collide

func _physics_process(delta):
	if get_colliding_bodies() != []:
		pos_final = global_position.x
		print("DISTANCIA ", str((pos_final-pos_inicial)/PIXEL_TO_CM).pad_decimals(2), ' metros')
		bb_collide.emit(self)
		queue_free()
	
	if is_shoot:
		last_point = global_position
		var velocity = Vector2(linear_velocity.x, linear_velocity.y).length()
		if first_vel:
			#print("Vel. Inicial: ", str(velocity/PIXEL_TO_CM).pad_decimals(2), 'm/s')
			#print("vel pixel ", velocity)
			first_vel = false
		
		#Aplicando o Backspin
		if velocity > 0:
			var magnus_direction = Vector2(abs(direction.x), direction.y)
			var magnus_force = magnus_direction.orthogonal() * sqrt(velocity)*backspin_drag
			apply_central_force(magnus_force)


func shoot_bb(spring_force, bb_mass, drag):
	backspin_drag = drag
	is_shoot = true
	pos_inicial = global_position.x
	mass = bb_mass
	var velocity:float = sqrt(2*spring_force / mass)*PIXEL_TO_CM #2 pixel = 1cm (122px/s*50 -> 122m/s)
	var impulse = direction * velocity
	apply_central_impulse(impulse)
