herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaNeutrones).

satisface(Cazafantasma, aspiradora(Potencia)):- tiene(Cazafantasma, aspiradora(PotenciaReal)), between(0, PotenciaReal, Potencia).

satisface(Cazafantasma, Herramienta):- tiene(Cazafantasma, Herramienta).

puedeRealizar(Cazafantasma, Tarea):- tiene(Cazafantasma, varitaNeutrones), herramientasRequeridas(Tarea, _).
puedeRealizar(Cazafantasma, Tarea):- tiene(Cazafantasma, _), 
                                     findall(Herramienta, tiene(Cazafantasma, Herramienta), Herramientas),
                                     herramientasRequeridas(Tarea, HerramientasRequeridas),
                                     subset( HerramientasRequeridas, Herramientas).
                                    
% tareaPedida(Cliente, Tarea, Metros).
% precio(Tarea, Precio).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

precio(ordenarCuarto, 10).
precio(limpiarTecho, 20).
precio(cortarPasto, 30).
precio(limpiarBanio, 40).
precio(encerarPisos, 50).

precioPorTarea(Cliente, Tarea, Precio):- precio(Tarea, PrecioPorMetro),
                                        tareaPedida(Tarea, Cliente, Metros),
                                        Precio is PrecioPorMetro* Metros.

presupuesto(Cliente, PrecioFinal):- tareaPedida(_, Cliente, _),
                                findall(Precio, precioPorTarea(Cliente, _, Precio), Precios),
                                sum_list(Precios   ,PrecioFinal).



dispuestoAceptar(Wachin, _):- tiene(Wachin, _), Wachin = peter.
dispuestoAceptar(winston, Cliente):-  tareaPedida(_, Cliente, _),
                                    presupuesto(Cliente, PrecioFinal),
                                    PrecioFinal>500.
dispuestoAceptar(ray, Cliente):- tareaPedida(_, Cliente, _), not(tareaPedida(limpiarTecho, Cliente, _)).
dispuestoAceptar(egon, Cliente):- not((tareaPedida(Cliente, Tarea, _),
                                        esCompleja(Tarea))).

esCompleja(Cliente):- tareaPedida(Tarea, Cliente, _),
                     herramientasRequeridas(Tarea, HerramientasRequeridas),
                     length(HerramientasRequeridas, CantidadHerramientas),
                     CantidadHerramientas>2.
esCompleja(limpiarTecho).



puedeRealizarTodasLasTareas(Cliente, Wachin):- forall(tareaPedida(Tarea, Cliente, _), puedeRealizar(Wachin, Tarea)),
                                                dispuestoAceptar(Wachin, Cliente).
