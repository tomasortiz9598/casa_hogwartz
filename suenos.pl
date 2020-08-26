cree(gabriel, campanita).
cree(gabriel, magoOz).
cree(gabriel, cavenaghi).
cree(juan, conejoPascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

sueno(gabriel, ganarLoteria([5, 9])).
sueno(gabriel, futbolista(arsenal)).
sueno(juan, cantante(100000)).
sueno(macarena, cantante(10000)).

persona(Persona):- cree(Persona, _).
personaje(Personaje) :- cree(_, Personaje).
%Como diego no cree en nadie utilizamos el concepto de universo cerrado y no lo agregamos en la base de conociemientos

dificultadSueno(cantante(CantidadDiscos), Dificultad):- not(between(0, 500000, CantidadDiscos)), Dificultad is 6.
dificultadSueno(cantante(CantidadDiscos), Dificultad):- between(0, 500000, CantidadDiscos), Dificultad is 4.
dificultadSueno( ganarLoteria(ListaNumeros), Dificultad):- length(ListaNumeros, CantidadNumeros),Dificultad is 10*CantidadNumeros.
dificultadSueno(futbolista(Equipo), Dificultad):- esEquipoChico(Equipo), Dificultad is 3.
dificultadSueno(futbolista(Equipo), Dificultad):- not(esEquipoChico(Equipo)), Dificultad is 3.

esEquipoChico(arsenal).
esEquipoChico(aldosivi).

esAmbiciosa(Persona):- persona(Persona),
                       findall(Dificultad, 
                                (sueno(Persona, Sueno), dificultadSueno(Sueno, Dificultad)),
                             Dificultades),
                        sum_list(Dificultades, SumaDificultades),
                        not(between(0, 20, SumaDificultades)).
        


tieneQuimica(Persona, campanita):- cree(Persona, campanita),
                                    sueno(Persona, Sueno),
                                    not(( dificultadSueno(Sueno, Dificultad), Dificultad>5)).
tieneQuimica(Persona, Personaje):- cree(Persona, Personaje),
                                      not((sueno(Persona, Sueno), not(esPuro(Sueno)))), 
                                    not(esAmbiciosa(Persona)).

esPuro(futbolista(_)).
esPuro(cantante(CantidadDiscos)):- between(0, 200000,CantidadDiscos).

amiga(campanita, reyesMagos).
amiga(campanita, conejoPascua).
amiga(conejoPascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoPascua).

personajeBackup(Personaje, PersonajeBackup) :-amiga(Personaje, PersonajeBackup).
personajeBackup(Personaje, PersonajeBackup) :-amiga(Personaje, OtroPersonaje),
                                            personajeBackup(OtroPersonaje, PersonajeBackup).

algunoSano(Personaje):-  not(estaEnfermo(Personaje)).
algunoSano(Personaje):-  personajeBackup(Personaje, PersonajeBackup) ,not(estaEnfermo(PersonajeBackup)).

puedeAlegrar(Personaje, Persona):- sueno(Persona, _),
                                    tieneQuimica(Persona,Personaje),
                                    algunoSano(Personaje).

                                

