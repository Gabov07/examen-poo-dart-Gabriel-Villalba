import 'dart:async'; 
import 'dart:math';

abstract class Preparable {
  Future<void> preparar();
}

abstract class Imprimible {
  String obtenerDescripcion();
}

abstract class Bebida implements Preparable, Imprimible {
  String nombre;
  double precio;

  Bebida(this.nombre, this.precio);
}

class Cafe extends Bebida {
  Cafe() : super('Café', 2.50);

  String obtenerDescripcion() {
    return '$nombre - \$${precio.toStringAsFixed(2)}';
  }

  Future<void> preparar() async {
    print('Moliendo granos y preparando café...');
    await Future.delayed(Duration(seconds: 2));
    print('Café listo.');
  }
}

class Te extends Bebida {
  Te() : super('Té', 1.75);

  String obtenerDescripcion() {
    return '$nombre - \$${precio.toStringAsFixed(2)}';
  }

  Future<void> preparar() async {
    print('Calentando agua y sirviendo té...');
    await Future.delayed(Duration(seconds: 1));
    print('Té listo.');
  }
}

class Jugo extends Bebida {
  Jugo() : super('Jugo de Naranja', 3.00);

  String obtenerDescripcion() {
    return '$nombre - \$${precio.toStringAsFixed(2)}';
  }

  Future<void> preparar() async {
    print('Exprimiendo naranjas...');
    await Future.delayed(Duration(seconds: 3));
    print('Jugo listo.');
  }
}

class Pedido {
  List<Bebida> items = [];
  String id;
  final _controlador = StreamController<String>();

  Pedido() : id = 'ORD-${Random().nextInt(100)}'; 

  Stream<String> get notificaciones => _controlador.stream;

  void agregarBebida(Bebida bebida) {
    items.add(bebida);
    print('Añadido al pedido ${this.id}: ${bebida.obtenerDescripcion()}');
  }

  Future<void> procesarPedido() async {
    _controlador.add('Iniciando preparación del pedido ${this.id}...');
    
    for (var bebida in items) {
      _controlador.add('Preparando ${bebida.nombre}...');
      await bebida.preparar(); 
    }

    _controlador.add('¡Pedido ${this.id} completado!');
    _controlador.close(); 
  }
}


void main() async {
  print('Cafetería Abierta\n');

  var cafe = Cafe();
  var te = Te();
  var jugo = Jugo();

  var pedido = Pedido();
  pedido.agregarBebida(cafe);
  pedido.agregarBebida(jugo);
  pedido.agregarBebida(te);

  print('\n-------------------------------------');

  pedido.notificaciones.listen((mensaje) {
    print('Notificación: $mensaje ');
  });

  await pedido.procesarPedido();

  print('-------------------------------------\n');
  print('Proceso del pedido finalizado.');
}