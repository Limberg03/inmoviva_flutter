import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  const CardContainer({Key? key, required this.child }):super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),  // espacios para los lados
        decoration: _createCardShape(),
        child: child,
      ),
    );
  }
  BoxDecoration _createCardShape() => BoxDecoration(
    color:  Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const[
      BoxShadow(  // caja de la sombra
        color: Colors.black,  // color de la sombra
        blurRadius: 30,  // exparsion de la sombra
        offset: Offset(0, 5)  // sombra  gral
      )
    ]
  );
}
