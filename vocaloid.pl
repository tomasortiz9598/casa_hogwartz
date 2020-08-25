vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).


sabeDosCanciones(Vocaloid) :- vocaloid(Vocaloid, Cancion), 
                              vocaloid(Vocaloid, OtraCancion),
                              Cancion \=OtraCancion.

tiempo(cancion(_, Tiempo), Tiempo).

tiempoDeCancion(Vocaloid, Tiempo) :- vocaloid(Vocaloid, Cancion),
                                     tiempo(Cancion, Tiempo).

listaTiemposCanciones(Vocaloid, ListaTiempos):- findall(Tiempo, tiempoDeCancion(Vocaloid, Tiempo) , ListaTiempos).

sumarTiempos(Vocaloid, TiempoTotal) :- listaTiemposCanciones(Vocaloid, ListaTiempos), 
                                        sum_list(ListaTiempos, TiempoTotal).

esNovedoso(Vocaloid) :- sabeDosCanciones(Vocaloid), sumarTiempos(Vocaloid, Tiempo), Tiempo=<15.

esAcelerado(Vocaloid) :- vocaloid(Vocaloid, _), not((tiempoDeCancion(Vocaloid, Tiempo), Tiempo>4)).

%concierto(Nombre, Pais, Fama, gigante(CantidadMinimaDeCanciones, TiempoMinimo)).
%concierto(Nombre, Pais, Fama, mediano( TiempoMaximo).
%concierto(Nombre, Pais, Fama, pequeno( TiempoMinimoDeAlgunaCancion).
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vokalektVision, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequeno(4)).

cantidadTemas(Vocaloid, CantidadTemas) :- findall(Cancion, vocaloid(Vocaloid, Cancion) , Canciones),
                                        length(Canciones, CantidadTemas).

cumpleCondicion(Vocaloid, gigante(CantidadMinimaDeCanciones, TiempoMinimo)):- cantidadTemas(Vocaloid, CantidadTemas),
                                                                                CantidadTemas>=CantidadMinimaDeCanciones,
                                                                                sumarTiempos(Vocaloid, TiempoTotal),
                                                                                TiempoTotal>=TiempoMinimo.
                                                                            
cumpleCondicion(Vocaloid, mediano( TiempoMaximo)):-  sumarTiempos(Vocaloid, TiempoTotal),
                                                    TiempoTotal=<TiempoMaximo.
cumpleCondicion(Vocaloid, pequeno( TiempoMinimoDeAlgunaCancion)):- not((tiempoDeCancion(Vocaloid, Tiempo),
                                                                         Tiempo=<TiempoMinimoDeAlgunaCancion )).

puedeParticipar(hatsuneMiku, Concierto):- concierto(Concierto, _, _, _).
puedeParticipar(Vocaloid, Concierto):- vocaloid(Vocaloid, _), concierto(Concierto, _, _, Requisito), Vocaloid\=hatsuneMiku, cumpleCondicion(Vocaloid, Requisito).
                                       

nivelFama(Vocaloid, Fama):- vocaloid(Vocaloid, _),findall(FamaConcierto,
                            (puedeParticipar(Vocaloid, Concierto), concierto(Concierto, _, FamaConcierto, _)),
                             Famas),
                             sum_list(Famas, Fama).

masFamoso(Vocaloid) :-vocaloid(Vocaloid, _), findall(Fama, nivelFama(_, Fama), Famas ),nivelFama(Vocaloid, FamaVocaloid), max_member(FamaVocaloid, Famas).

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoEnConcierto(Vocaloid) :- vocaloid(Vocaloid, _),
                             puedeParticipar(Vocaloid, Concierto),
                             not((conoce(Vocaloid, Amigo),conoce(Amigo, OtroAmigo),
                                 puedeParticipar(Amigo, Concierto),  puedeParticipar(OtroAmigo, Concierto))).
