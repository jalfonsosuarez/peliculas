import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
    'Capitan América'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan América'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar 
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando se escribe

    if( query.isEmpty ) {
      return Container();
    } 

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: ( BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot ) {
        
        if ( snapshot.hasData ) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map( (pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close( context, null );
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula );
                },
              );
            }).toList(),
          );


        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }

      },
    );

  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que aparecen cuando se escribe

  //   final listaSugerida =  ( query.isEmpty ) ? 
  //                           peliculasRecientes : 
  //                           peliculas.where( 
  //                             (p) => p.toLowerCase().startsWith(query.toLowerCase() ) 
  //                           ).toList();


  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text( listaSugerida[i]),   
  //         onTap: () {
  //           seleccion = listaSugerida[i];
  //           showResults(context);
  //         },       
  //       );
  //     },
  //   );
  // }

}