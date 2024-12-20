import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete

class DetallesInventarioPage extends StatefulWidget {
  @override
  _DetallesInventarioPageState createState() => _DetallesInventarioPageState();
}

class _DetallesInventarioPageState extends State<DetallesInventarioPage> {
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Inventario inventario =
        ModalRoute.of(context)?.settings.arguments as Inventario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Propiedad'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(inventario),
              SizedBox(height: 20),
              _buildInfo('Dirección', inventario.direccion ?? 'No especificada',
                  Icons.location_on),
              _buildInfo('Estado', inventario.estado ?? 'No disponible',
                  Icons.info_outline),
              _buildInfo(
                  'Precio',
                  '\$${inventario.precio?.toStringAsFixed(2) ?? '0.00'}',
                  Icons.attach_money,
                  textColor: Colors.green[700]),
              _buildInfo(
                  'Superficie',
                  '${inventario.superficie?.toStringAsFixed(2)} m²',
                  Icons.square_foot),
              _buildInfo(
                  'Descripción',
                  inventario.descripcion ?? 'Sin descripción',
                  Icons.description),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (Platform.isWindows) {
      // En Windows, abre el navegador con el comando predeterminado
      await Process.start('cmd', ['/c', 'start', url]);
    } else if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir la URL $url';
    }
  }

  Widget _buildInfo(String label, String value, IconData icon,
      {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: label == 'Dirección'
                ? GestureDetector(
                    onTap: () {
                      final url =
                          'https://www.google.com/maps?q=$value'; // URL de Google Maps
                      _launchURL(url); // Llama a la función que lanza la URL
                    },
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: 16,
                          color: textColor ??
                              Colors
                                  .blue), // Estilo en azul para indicar que es clicable
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                        fontSize: 16, color: textColor ?? Colors.grey[800]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(Inventario inventario) {
    if (inventario.imagenes != null && inventario.imagenes!.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: inventario.imagenes!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          imagePaths: inventario.imagenes!,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(
                        File(inventario.imagenes![index]),
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(inventario.imagenes!.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: _currentImageIndex == index ? 12.0 : 8.0,
                  height: _currentImageIndex == index ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Colors.blueAccent
                        : Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
        child: Icon(Icons.image, size: 80, color: Colors.grey),
      );
    }
  }
}

class FullScreenImagePage extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  FullScreenImagePage({required this.imagePaths, required this.initialIndex});

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPage = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagen en Pantalla Completa'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.file(
                  File(widget.imagePaths[index]),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
          // Flecha para ir a la imagen anterior
          if (_currentPage > 0)
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          // Flecha para ir a la imagen siguiente
          if (_currentPage < widget.imagePaths.length - 1)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 30),
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
