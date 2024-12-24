import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEPO',
      theme: ThemeData(
        primaryColor: Color(0xFF63B2DC),
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSlide = 0;
  final ScrollController _scrollController = ScrollController();
  final List<Item> _cartItems = [];

  final List<String> _slides = [
    'assets/images/Grafica.png',
    'assets/images/Placa Madre.png',
    'assets/images/Audifonos.png',
    'assets/images/Procesador Intel.png',
    'assets/images/Procesador Amd.png',
  ];

  void _nextSlide() {
    setState(() {
      _currentSlide = (_currentSlide + 1) % _slides.length;
    });
  }

  void _prevSlide() {
    setState(() {
      _currentSlide = (_currentSlide - 1 + _slides.length) % _slides.length;
    });
  }

  void _scrollToSection(int sectionIndex) {
    double offset = sectionIndex == 0 ? 600.0 : 1200.0;
    _scrollController.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _addToCart(Item item) {
    setState(() {
      _cartItems.add(item);
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} añadido al carrito')),
    );
  }

  void _showProductPopup(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item.image),
              SizedBox(height: 10),
              Text(
                'Precio Original: ${item.originalPrice}',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Precio con Descuento: ${item.discountedPrice}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () => _addToCart(item),
              child: Text('Añadir al Carrito'),
            ),
          ],
        );
      },
    );
  }

  void _openCart() {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productos en el Carrito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003254),
                  ),
                ),
                SizedBox(height: 20),
                if (_cartItems.isEmpty)
                  Center(
                    child: Text(
                      'El carrito está vacío.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _cartItems.map((item) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Image.asset(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Precio: ${item.discountedPrice}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _cartItems.remove(item);  // Eliminar el producto al instante
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${item.title} ha sido eliminado.')),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_cartItems.isNotEmpty) Divider(),
                if (_cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Total: \$${_cartItems.fold(0, (sum, item) => sum + int.parse(item.discountedPrice.replaceAll('\$', '').replaceAll('.', '')))}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003254),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_cartItems.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          // Lógica de pago (agregar si es necesario)
                        },
                        child: Text(
                          'Proceder al Pago',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF63B2DC),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    if (_cartItems.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cartItems.clear(); // Vaciar el carrito al instante
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('El carrito ha sido vaciado.')),
                          );
                        },
                        child: Text(
                          'Vaciar Carrito',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}




  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/LOGO PAGINA.png', height: 50),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.computer),
                  onPressed: () => _scrollToSection(0),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: () => _scrollToSection(1),
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: _openCart,
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: _goToProfile, // Llamamos a la pantalla de inicio de sesión
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xFF63B2DC),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _slides[_currentSlide],
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 100,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: _prevSlide,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 100,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                    onPressed: _nextSlide,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Section(
              title: 'Sección de Hardware',
              items: hardwareItems,
              onItemPressed: _showProductPopup,
            ),
            SizedBox(height: 20),
            Section(
              title: 'Sección de Periféricos',
              items: peripheralItems,
              onItemPressed: _showProductPopup,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();  // Para el registro
  final _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;  // Controlar si mostrar el formulario de registro o login

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes agregar la lógica de autenticación o registro
      String action = _isRegistering ? 'Registrando' : 'Iniciando sesión';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Registrarse' : 'Iniciar Sesión'),
        backgroundColor: Color(0xFF63B2DC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isRegistering ? 'Crear Cuenta' : 'Iniciar Sesión',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo electrónico';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      }
                      return null;
                    },
                  ),
                  if (_isRegistering) ...[
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirme su contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isRegistering ? 'Registrarse' : 'Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF63B2DC),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isRegistering
                          ? '¿Ya tienes cuenta? '
                          : '¿No tienes cuenta? '),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isRegistering = !_isRegistering;
                          });
                        },
                        child: Text(_isRegistering ? 'Iniciar Sesión' : 'Regístrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Item> items;
  final Function(Item) onItemPressed;

  Section({required this.title, required this.items, required this.onItemPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003254),
            ),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => onItemPressed(item),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item.image, width: 100, height: 100),
                      SizedBox(height: 10),
                      Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(item.discountedPrice),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Item {
  final String title;
  final String image;
  final String originalPrice;
  final String discountedPrice;

  Item({
    required this.title,
    required this.image,
    required this.originalPrice,
    required this.discountedPrice,
  });
  
  get id => null;
}

final List<Item> hardwareItems = [
  Item(title: 'Crucial BX500 240 GB', image: 'assets/images/ssd.jpg', originalPrice: '\$21.500', discountedPrice: '\$18.900'),
  Item(title: 'EVGA GeForce RTX 3060 Ti', image: 'assets/images/grafica.jpg', originalPrice: '\$325.990', discountedPrice: '\$310.000'),
  Item(title: 'MSI MEG Z790 ACE', image: 'assets/images/Placa.png', originalPrice: '\$545.990', discountedPrice: '\$529.900'),
  Item(title: 'Memoria RAM Corsair 16GB', image: 'assets/images/rams.jpg', originalPrice: '\$85.990', discountedPrice: '\$79.000'),
  Item(title: 'Intel Core i5-14600K', image: 'assets/images/intel.jpg', originalPrice: '\$293.990', discountedPrice: '\$283.700'),
  Item(title: 'AMD Ryzen 7 5800X', image: 'assets/images/amd.jpg', originalPrice: '\$225.990', discountedPrice: '\$214.990'),
  Item(title: 'EVGA 700W', image: 'assets/images/fuente.png', originalPrice: '\$77.990', discountedPrice: '\$68.990'),
  Item(title: 'Western Digital Black 500 GB', image: 'assets/images/NVME.jpg', originalPrice: '\$55.990', discountedPrice: '\$47.900'),
  Item(title: 'Corsair Air Series AF140 LED', image: 'assets/images/ventilador.png', originalPrice: '\$21.990', discountedPrice: '\$15.000'),
  Item(title: 'Kingston Fury Beast', image: 'assets/images/Ram2.jpg', originalPrice: '\$65.990', discountedPrice: '\$58.600'),
];

final List<Item> peripheralItems = [
  Item(title: 'Mousepad Logitech G240', image: 'assets/images/mousepad.png', originalPrice: '\$11.990', discountedPrice: '\$7.990'),
  Item(title: 'Samsung S24AG32', image: 'assets/images/monitor.jpg', originalPrice: '\$125.990', discountedPrice: '\$119.900'),
  Item(title: 'Samsung Odyssey G4', image: 'assets/images/monitor240.jpg', originalPrice: '\$255.990', discountedPrice: '\$235.990'),
  Item(title: 'Mouse Razer Viper V2 Pro', image: 'assets/images/mouse.jpg', originalPrice: '\$125.990', discountedPrice: '\$115.990'),
];