mago(harry, mestiza, [coraje, amistoso, orgullo, inteligencia], odia(slytherin)).
mago(draco, pura, [ orgullo, inteligencia], odia(hufflepuff)).
mago(hermione, impura, [responsabilidad, orgullo, inteligencia], odia()).

casa(gryffindor, [coraje]).
casa(slytherin, [orgullo, inteligencia]).
casa(ravenclaw, [responsabilidad, inteligencia]).
casa(hufflepuff, [amistoso]).


excepcionSlytherin(Casa, Mago):- Casa = slytherin, mago(Mago, Sangre, _, _), Sangre =impura.

permiteEntrar(Casa, Mago) :- mago(Mago, _, _, _), casa(Casa, _), not(excepcionSlytherin(Casa, Mago)).


caracterApropiado(Casa, Mago) :-  casa(Casa, Exigencias),
                                  mago(Mago, _, Caracteristicas, _),
                                  subset(Exigencias, Caracteristicas).
                                

loQueOdia(odia(Casa), Casa).

puedeQuedar(Casa, Mago) :- caracterApropiado(Casa, Mago),
                          permiteEntrar(Casa, Mago),
                          mago(Mago, _, _, Odia),
                          loQueOdia(Odia, CasaOdiada),
                          CasaOdiada\=Casa.
puedeQuedar(gryffindor, hermione).


esAmistoso(Mago) :- mago(Mago, _, Caracteristicas, _), member(amistoso, Caracteristicas).

cadenaDeAmistades([Amigo]) :- esAmistoso(Amigo).
cadenaDeAmistades([Amigo, OtroAmigo | Amigos]):- esAmistoso(Amigo),
                                                    esAmistoso(OtroAmigo),
                                                    puedeQuedar(Casas, Amigo),
                                                    puedeQuedar(OtraCasas, OtroAmigo),
                                                    Casas = OtraCasas,
                                                    cadenaDeAmistades([OtroAmigo | Amigos]).


accion(harry, fueraDeCama, -50).
accion(hermione, irATercerPiso, -75).
accion(hermione, irASeccionRestringida, -10).
accion(harry, irABosque, -50).
accion(harry, irATercerPiso, -75).
%accion( draco, isAMazmorras, 0).
accion( ron, ganarAjedrezMagico, 50).
accion( hermione, salvaAmigos, 50).
accion( harry, ganarleAVoldemort, 60).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

esBuenAlumno(Mago) :- forall(accion( Mago, _, Puntaje), Puntaje>0).

esRecurrente(Accion) :- findall(Accion,accion( _, Accion, _) , Acciones ), length(Acciones, Cantidad), Cantidad >1.

puntajeMago(Mago, Puntaje) :- findall(Puntos, accion(Mago, _, Puntos ), Puntajes), sumlist(Puntajes, Puntaje).


puntajeTotal(Casa, Puntaje) :-findall(Puntos,
                                     ( esDe(Magos, Casa), puntajeMago(Magos, Puntos)),
                                      Puntajes),
                              sumlist(Puntajes, Puntaje).

ganadora(Casa) :- findall(Puntaje, (casa(Casas, _), puntajeTotal(Casas, Puntaje)), Puntajes),puntajeTotal(Casa, PuntajeDeCasa), max_member(PuntajeDeCasa, Puntajes).
