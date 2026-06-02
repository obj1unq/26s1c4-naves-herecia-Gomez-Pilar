class NaveBase {
	var property velocidad 
	const property limite = 300000
	method propulsar() {
		self.aumentarVelocidad(20000)
	}

	method aumentarVelocidad(cantidad) {
		velocidad = (velocidad + cantidad).min(limite)
	}

	method prepararParaViajar() {
		self.aumentarVelocidad(15000)
	}
}

class NaveDeCarga inherits NaveBase {
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeCargaRadiactiva inherits NaveDeCarga {
	var property sellada = false

	override method recibirAmenaza() {
		self.sellarAlVacio()
	}

	override method prepararParaViajar() {
		self.sellarAlVacio()
		super()
	}

	method sellarAlVacio() {
		sellada = true
		velocidad = 0
	}
}

class NaveDePasajeros inherits NaveBase {
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits NaveBase {
	var property modo = Reposo
	const property mensajesEmitidos = []

	override method prepararParaViajar() {
		modo.preparar(self)
		super()
	}

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

}

class Modo {
	const property mensajeAmenaza
	const property mensajePreparar 

	method mensajeAmenaza() // METODO ABSTRACTO, en el new lo definis

	method mensajePreparar()

    method recibirAmenaza(nave) {
		nave.emitirMensaje(self.mensajeAmenaza())
	}

	method prepararParaViaje(nave) {
		nave.emitirMensaje(self.mensajePreparar())
	}
}

class Reposo inherits Modo {

	const modoPreparar = Ataque

	method invisible() = false

	override method mensajeAmenaza() = "RETIRADA"

	override method mensajePreparar() = "Saliendo de mision"

	override method prepararParaViaje(nave) {
		super(nave)
		nave.modo(modoPreparar)
	}

}

class Ataque inherits Modo {

	method invisible() = true

	override method mensajeAmenaza() = "Enemigo encontrado"

	override method mensajePreparar() = "Volviendo a la base"
}

