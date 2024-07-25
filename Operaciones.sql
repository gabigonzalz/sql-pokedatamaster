-- OPERACIONES-------------------------------------------------------------------------------------------------

--INSERT-------------------------------------------------------------------------------------------------
  -- Insertamos datos a nuestra tabla de batallas_entrenadores (9 FILAS)
INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (1,1,1,true);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (2,2,1,false);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (3,3,2,false);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (4,4,2,true);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (5,5,3,true);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (6,6,3,true);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (7,7,3,false);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (8,8,4,false);

INSERT INTO batallas_entrenadores (id,entrenadorid , batallaid , ganador)
VALUES (9,9,4,true);

  -- Insertamos una relacion pokemon mas
INSERT INTO relaciones (entrenadorid , pokemonid , apodo,nivel,ataque,defensa,genero)
VALUES (2,3,'Hamu',45,67,87,'M');


--UPDATE------------------------------------------------------------------------------------------------
  -- Actualizamos el nombre y la edad de uno de los entrenadores
UPDATE entrenadores 
SET nombre = 'Alise' , edad = 17
WHERE nombre = 'Iris';

  -- Actualizamos a uno de los pokemones
UPDATE relaciones 
SET apodo = 'Gux' , nivel = 60, ataque = 68, defensa = 99
WHERE idrelaciones = 12;


--DELETE-------------------------------------------------------------------------------------------------
  -- Eliminamos a un pokemon, su entrenador lo libero
DELETE FROM relaciones WHERE idrelaciones = 20;

  -- Eliminamos el registro de un entrenador, se retiro
DELETE FROM entrenadores WHERE id = 19;

  -- Anadir un nuevo tipo raza de pokemon y unirlo con un entrenador luego eliminalo la raza
-- Nueva raza
INSERT INTO pokemones (nombre , tipo , habilidad,hp)
VALUES ('Arcanine','Fire','Flash fire',90);
-- Nueva relacion
INSERT INTO relaciones (entrenadorid, pokemonid, apodo,nivel, ataque, defensa, genero)
VALUES (15, 43,'Hula',40,67,87,'M');
-- Eliminar de ambos
DELETE FROM pokemones WHERE id = 43;
-- Y se elimina de pokemones y de relaciones porque dejo de existir la raza y las columnas tienen cascade


-- CREATE & OPERACIONES MULTI-TABLE-----------------------------------------------------------------------
  -- Tabla de cantidad de pokemones por entrenador
CREATE OR REPLACE VIEW cantidad_pokemones_por_entrenador AS
SELECT entrenadores.nombre, 
       COALESCE(relaciones.NumPokemones, 0) AS NumPokemones
FROM entrenadores
LEFT JOIN (
    SELECT entrenadorid, COUNT(*) AS NumPokemones
    FROM relaciones
    GROUP BY entrenadorid
) AS relaciones ON entrenadores.Id = relaciones.entrenadorid 
ORDER BY numpokemones desc;
  -- Consultar la vista
SELECT * FROM cantidad_pokemones_por_entrenador;


  -- Tabla de ganadores de todas las batallas
CREATE OR REPLACE VIEW entrenadores_ganadores AS
SELECT entrenadores.nombre, batallas_entrenadores.ganador 
FROM batallas_entrenadores
JOIN entrenadores ON batallas_entrenadores.entrenadorid = entrenadores.Id
WHERE batallas_entrenadores.ganador = true 
order BY nombre;
  -- Consultar la vista
SELECT * FROM entrenadores_ganadores;


  -- Tabla de pokemones por entrenador
CREATE OR REPLACE VIEW pokemones_por_entrenador AS
select entrenadores.nombre, pokemones.nombre as Raza, pokemones.tipo, relaciones.apodo,
relaciones.nivel, pokemones.hp, relaciones.ataque, relaciones.defensa, relaciones.genero
from relaciones
join entrenadores ON entrenadores.id = relaciones.entrenadorid 
join pokemones ON pokemones.id =  relaciones.pokemonid 
order by entrenadores.nombre;
 --Consultar vista
SELECT * FROM pokemones_por_entrenador;

-- Lista de batallas por entrenadores
CREATE OR REPLACE VIEW datos_batallas_entrenadores as
SELECT batallas.fecha, entrenadores.nombre, batallas_entrenadores.ganador, batallas.idbatalla 
FROM batallas
LEFT JOIN batallas_entrenadores ON batallas.idbatalla = batallas_entrenadores.batallaid
LEFT JOIN entrenadores ON batallas_entrenadores.entrenadorid = entrenadores.id
ORDER BY batallas.fecha desc;
 --Consultar vista
SELECT * FROM datos_batallas_entrenadores;

  -- Lista de batallas por pokemones
CREATE OR REPLACE VIEW datos_batallas_pokemones as
SELECT batallas.fecha, pokemones.nombre, relaciones.apodo, batallas_entrenadores.ganador
FROM batallas
LEFT JOIN batallas_pokemones ON batallas.idbatalla = batallas_pokemones.batallaid
LEFT JOIN relaciones ON batallas_pokemones.pokemonid = relaciones.idrelaciones
LEFT JOIN pokemones ON relaciones.pokemonid = pokemones.id
LEFT JOIN batallas_entrenadores ON batallas_pokemones.batallaid = batallas_entrenadores.batallaid and relaciones.entrenadorid = batallas_entrenadores.entrenadorid 
ORDER BY batallas.fecha desc;
 --Consultar vista
SELECT * FROM datos_batallas_pokemones;

