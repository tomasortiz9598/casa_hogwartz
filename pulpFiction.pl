personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%etc

esActividadNoPeligrosa(mafioso(maton)).
esActividadNoPeligrosa(ladron(ListaDeLugares)):- member(licorerias, ListaDeLugares).

esPeligroso(Personaje) :- personaje(Personaje, Actividad), esActividadNoPeligrosa(Actividad).
esPeligroso(Personaje) :- trabajaPara(Personaje, Empleado), esPeligroso(Empleado).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

sonPeligrosos(Personaje, OtroPersonaje):- esPeligroso(Personaje),esPeligroso(OtroPersonaje).

duoTemible(Personaje, OtroPersonaje):- sonPeligrosos(Personaje, OtroPersonaje), pareja(Personaje, OtroPersonaje).
duoTemible(Personaje, OtroPersonaje):- sonPeligrosos(Personaje, OtroPersonaje), amigo(Personaje, OtroPersonaje).


%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).


estaEnProblemas(Personaje):- personaje(Personaje,_),
                             trabajaPara(Jefe, Personaje),
                             esPeligroso(Jefe),
                             encargo(Jefe, Personaje, cuidar(PersonaACuidar) ),
                             pareja(Personaje, PersonaACuidar).
estaEnProblemas(Personaje):- personaje(Personaje,_),
                            encargo(_, Personaje, buscar(PersonaABuscar, _) ),
                            personaje(PersonaABuscar, boxeador).
estaEnProblemas(Personaje):- personaje(Personaje, _), Personaje=butch.

tieneCerca(Personaje, OtroPersonaje):- amigo(Personaje, OtroPersonaje).
tieneCerca(Personaje, OtroPersonaje):- trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje):- tieneCerca(Personaje, OtroPersonaje),
                         encargo(Personaje, OtroPersonaje, _).


tareaPorPersonaje(Personaje, CantidadDeTareas):- personaje(Personaje, _),
                                                findall(Tarea, encargo(_, Personaje, Tarea ), Tareas),
                                                length(Tareas, CantidadDeTareas).


masAtareado(Personaje):- personaje(Personaje, _),
                        findall(CantTareasPorPersonaje,
                                 (personaje(TodoPersonaje, _), tareaPorPersonaje(TodoPersonaje, CantTareasPorPersonaje)),
                                 CantTareas),
                        tareaPorPersonaje(Personaje, CantidadDeTareas),
                        max_member(CantidadDeTareas, CantTareas).

nivelRespeto(actriz(ListaPeliculas), NivelRespeto):- length(ListaPeliculas, CantidadPeliculas),
                                                    NivelRespeto is div(CantidadPeliculas, 10).
nivelRespeto(mafioso(resuelveProblemas), NivelRespeto):- NivelRespeto is 10.
nivelRespeto(mafioso(maton), NivelRespeto):- NivelRespeto is 1.
nivelRespeto(mafioso(capo), NivelRespeto):- NivelRespeto is 20.

personajesRespetables(Personajes):- findall(PersonajeRespetable,
                                            (personaje(PersonajeRespetable, Actividad), nivelRespeto(Actividad, NivelRespeto), not(between(0, 9, NivelRespeto))),
                                            Personajes).

involucrada(cuidar(Persona), Persona).
involucrada(ayudar(Persona), Persona).
involucrada(buscar(Persona, _), Persona).

hartoDe(Personaje, OtroPersonaje):- personaje(Personaje, _), personaje(OtroPersonaje, _), encargo(_, Personaje, Actividad), involucrada(Actividad, OtroPersonaje).
hartoDe(Personaje, OtroPersonaje):- amigo(OtroPersonaje, Amigo), hartoDe(Personaje, Amigo).


caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(Personaje, OtroPersonaje):-caracteristicas(Personaje, CaracteristicasPersonaje),
                                            caracteristicas(OtroPersonaje, CaracteristicasOtroPersonaje),
                                            not(permutation(CaracteristicasPersonaje, CaracteristicasOtroPersonaje)).
