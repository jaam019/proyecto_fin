-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-05-2023 a las 23:11:10
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto_ganadero`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `actualizarTelefonoVeterinario` (`id` INT, `nuevo_telefono` INT) RETURNS INT(11)  BEGIN
  DECLARE numRows INT;
  
  UPDATE veterinario
  SET telefono = nuevo_telefono
  WHERE id_veterinario = id;
  
  SET numRows = ROW_COUNT();
  
  RETURN numRows;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `calcularPromedioPesoTipoAnimal` (`idTipoAnimal` INT) RETURNS DECIMAL(10,2)  BEGIN
  DECLARE promedio DECIMAL(10,2);
  
  SELECT AVG(peso) INTO promedio
  FROM animal
  WHERE id_tipo_animal = idTipoAnimal;
  
  RETURN promedio;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insertarVeterinario` (`id` INT, `nombre` VARCHAR(20), `telefono` INT, `especializacion` VARCHAR(30)) RETURNS INT(11)  BEGIN
    DECLARE numRows INT;
    
    INSERT INTO veterinario (id_veterinario, nombre, telefono, especializacion)
    VALUES (id, nombre, telefono, especializacion);
    
    SET numRows = ROW_COUNT();
    
    RETURN numRows;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insertar_suministro` (`p_id_suministro` INT, `p_hora` TIME, `p_cantidad` INT, `p_id_trabajador` INT, `p_id_animal` INT, `p_id_alimento` INT) RETURNS INT(11)  BEGIN
  INSERT INTO suministro (id_suministro, hora, cantidad, id_trabajador, id_animal, id_alimento)
  VALUES (p_id_suministro, p_hora, p_cantidad, p_id_trabajador, p_id_animal, p_id_alimento);
  
  RETURN LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `modificar_animal` (`animal_id` INT, `new_peso` INT, `new_edad` INT, `new_genero` VARCHAR(50), `new_tipo_animal` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
  DECLARE message VARCHAR(50);

  UPDATE `animal`
  SET
    `peso` = new_peso,
    `edad` = new_edad,
    `genero` = new_genero,
    `id_tipo_animal` = new_tipo_animal
  WHERE
    `id_animal` = animal_id;

  IF ROW_COUNT() > 0 THEN
    SET message = 'Animal actualizado correctamente.';
  ELSE
    SET message = 'No se encontró ningún animal con el ID especificado.';
  END IF;

  RETURN message;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `modificar_chequeo` (`p_id_chequeo` INT, `p_fecha_chequeo` DATETIME, `p_peso` VARCHAR(150), `p_recomendaciones` VARCHAR(50), `p_id_veterinario` INT, `p_id_procedimiento` INT, `p_id_animal` INT) RETURNS TINYINT(1)  BEGIN
  DECLARE rows_affected INT;

  UPDATE chequeo
  SET fecha_chequeo = p_fecha_chequeo,
      peso = p_peso,
      recomendaciones = p_recomendaciones,
      id_veterinario = p_id_veterinario,
      id_procedimiento = p_id_procedimiento,
      id_animal = p_id_animal
  WHERE id_chequeo = p_id_chequeo;

  SET rows_affected = ROW_COUNT();

  IF rows_affected > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `modificar_procedimiento` (`p_id_procedimiento` INT, `p_fecha_chequeo` DATETIME, `p_id_tipo` INT) RETURNS TINYINT(1)  BEGIN
  DECLARE rows_affected INT;

  UPDATE procedimiento
  SET fecha_chequeo = p_fecha_chequeo,
      id_tipo = p_id_tipo
  WHERE id_procedimiento = p_id_procedimiento;

  SET rows_affected = ROW_COUNT();

  IF rows_affected > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `modificar_tipo` (`p_id_tipo` INT, `p_nuevo_tipo` VARCHAR(150)) RETURNS INT(11)  BEGIN
    DECLARE rows_affected INT;

    UPDATE tipo
    SET tipo = p_nuevo_tipo
    WHERE id_tipo = p_id_tipo;

    SET rows_affected = ROW_COUNT();

    RETURN rows_affected;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `obtenerCantidadAnimalesPorGenero` (`genero` VARCHAR(10)) RETURNS INT(11)  BEGIN
  DECLARE cantidad INT;
  
  SELECT COUNT(*) INTO cantidad
  FROM animal
  WHERE genero = genero;
  
  RETURN cantidad;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `obtenerCantidadAnimalesPorRangoEdad` (`edadMinima` INT, `edadMaxima` INT) RETURNS INT(11)  BEGIN
  DECLARE cantidad INT;
  
  SELECT COUNT(*) INTO cantidad
  FROM animal
  WHERE edad >= edadMinima AND edad <= edadMaxima;
  
  RETURN cantidad;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `obtenerCantidadAnimalesTipo` (`idTipoAnimal` INT) RETURNS INT(11)  BEGIN
  DECLARE cantidad INT;
  
  SELECT COUNT(*) INTO cantidad
  FROM animal
  WHERE id_tipo_animal = idTipoAnimal;
  
  RETURN cantidad;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alimento`
--

CREATE TABLE `alimento` (
  `id_alimento` int(11) NOT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  `id_tipo_alimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alimento`
--

INSERT INTO `alimento` (`id_alimento`, `nombre`, `id_tipo_alimento`) VALUES
(1, 'cebada', 1),
(2, 'leguminosa', 2),
(3, 'paja', 3),
(4, 'maiz', 4),
(5, 'concentrado', 5),
(6, 'forraje', 6),
(7, 'avena', 7),
(8, 'cholado', 8),
(9, 'soja', 9),
(10, 'alfalfa', 10),
(11, 'pasto', 11),
(12, 'caña', 12),
(13, 'verdura', 13),
(14, 'fruta', 14),
(15, 'forraje', 15);

--
-- Disparadores `alimento`
--
DELIMITER $$
CREATE TRIGGER `trigger_actualizar_alimento` AFTER INSERT ON `alimento` FOR EACH ROW BEGIN
 INSERT INTO log_alimento (nombre_alimento, fecha) VALUES (NEW.nombre, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_actualizar_tipo_alimento` AFTER INSERT ON `alimento` FOR EACH ROW BEGIN
    UPDATE tipo_alimento SET nombre = NEW.nombre WHERE id_tipo_alimento = NEW.id_tipo_alimento;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal`
--

CREATE TABLE `animal` (
  `id_animal` int(11) NOT NULL,
  `peso` int(50) DEFAULT NULL,
  `edad` int(50) DEFAULT NULL,
  `genero` varchar(50) DEFAULT NULL,
  `id_tipo_animal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal`
--

INSERT INTO `animal` (`id_animal`, `peso`, `edad`, `genero`, `id_tipo_animal`) VALUES
(1, 350, 3, 'Macho', 2),
(2, 320, 2, 'Hembra', 2),
(3, 720, 2, 'Hembra', 3),
(4, 650, 2, 'Hembra', 3),
(5, 520, 2, 'Hembra', 5),
(6, 633, 2, 'Hembra', 6),
(7, 640, 2, 'Hembra', 7),
(8, 650, 2, 'Hembra', 8),
(9, 650, 2, 'Hembra', 9),
(10, 400, 2, 'Hembra', 10),
(11, 452, 2, 'Hembra', 11),
(12, 390, 2, 'Hembra', 12),
(13, 364, 2, 'Hembra', 13),
(14, 365, 2, 'Hembra', 14),
(15, 405, 2, 'Hembra', 15);

--
-- Disparadores `animal`
--
DELIMITER $$
CREATE TRIGGER `after_delete_animal` AFTER DELETE ON `animal` FOR EACH ROW BEGIN
    DELETE FROM chequeo WHERE id_animal = OLD.id_animal;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_animal` BEFORE UPDATE ON `animal` FOR EACH ROW BEGIN
    DECLARE max_peso INT;
    SET max_peso = 1000; -- Valor máximo permitido para el peso
    
    IF NEW.peso > max_peso THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El peso excede el límite permitido.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chequeo`
--

CREATE TABLE `chequeo` (
  `id_chequeo` int(11) NOT NULL,
  `fecha_chequeo` datetime DEFAULT NULL,
  `peso` varchar(150) DEFAULT NULL,
  `recomendaciones` varchar(50) DEFAULT NULL,
  `id_veterinario` int(11) DEFAULT NULL,
  `id_procedimiento` int(11) DEFAULT NULL,
  `id_animal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `chequeo`
--

INSERT INTO `chequeo` (`id_chequeo`, `fecha_chequeo`, `peso`, `recomendaciones`, `id_veterinario`, `id_procedimiento`, `id_animal`) VALUES
(1, '2023-05-10 09:00:00', '550', 'Revisión adicional requerida', 1, 1, 1),
(2, '2023-04-28 11:13:36', '500', 'no exceder el alimento', 2, 2, 2),
(3, '2023-04-28 12:13:36', '450', 'mantener alimentación balanceada', 3, 3, 3),
(4, '2023-04-29 09:13:36', '410', 'proporcionar dos comidas al dia', 4, 4, 4),
(5, '2023-04-29 10:13:36', '300', 'mantener el peso según  el crecimiento de esta vac', 5, 5, 5),
(6, '2023-04-30 10:13:36', '400', 'es necesario aplicar purgante a esta vaca', 6, 6, 6),
(7, '2023-05-01 09:13:36', '550', 'esta en sobrepeso y necesita una dieta balaceada ', 7, 7, 7),
(8, '2023-05-01 16:13:36', '410', 'mantener bajo revisión de líquidos ', 8, 8, 8),
(9, '2023-05-03 16:13:36', '530', 'la vaca esta en proceso de gestación ', 9, 9, 9),
(10, '2023-04-28 13:26:53', '450', 'esta vaca ya esta para la producción de leche', 10, 10, 10),
(11, '2023-05-03 16:29:31', '490', 'seguir con el proceso del especialista ', 11, 11, 11),
(12, '2023-04-29 16:34:30', '150', 'seguimiento en proceso nutricional ', 12, 12, 12),
(13, '2023-05-01 16:34:30', '240', 'mantener el proceso de lactancia ', 13, 13, 13),
(14, '2023-04-28 13:26:53', '420', 'debe mantener el peso adecuado durante tres meses ', 14, 14, 15),
(15, '2023-05-03 16:29:31', '380', 'necita vitaminas para el desarrollo', 15, 15, 15);

--
-- Disparadores `chequeo`
--
DELIMITER $$
CREATE TRIGGER `after_insert_chequeo` AFTER INSERT ON `chequeo` FOR EACH ROW BEGIN
    UPDATE animal
    SET ultima_insercion = NOW()
    WHERE id_animal = NEW.id_animal;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procedimiento`
--

CREATE TABLE `procedimiento` (
  `id_procedimiento` int(11) NOT NULL,
  `fecha_chequeo` datetime DEFAULT NULL,
  `id_tipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `procedimiento`
--

INSERT INTO `procedimiento` (`id_procedimiento`, `fecha_chequeo`, `id_tipo`) VALUES
(1, '2023-05-10 09:00:00', 3),
(2, '2023-04-29 14:26:53', 2),
(3, '2023-04-28 13:26:53', 3),
(4, '2023-04-28 14:26:53', 4),
(5, '2023-04-29 14:26:53', 5),
(6, '2023-04-30 11:26:53', 6),
(7, '2023-05-01 11:26:53', 7),
(8, '2023-05-01 11:26:53', 8),
(9, '2023-04-02 11:26:53', 9),
(10, '2023-04-02 11:26:53', 10),
(11, '2023-04-03 11:26:53', 6),
(12, '2023-04-03 11:26:53', 12),
(13, '2023-04-03 11:26:53', 13),
(14, '2023-04-04 11:26:53', 14),
(15, '2023-04-04 11:26:53', 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suministro`
--

CREATE TABLE `suministro` (
  `id_suministro` int(11) NOT NULL,
  `hora` time DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `id_trabajador` int(11) DEFAULT NULL,
  `id_animal` int(11) DEFAULT NULL,
  `id_alimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `suministro`
--

INSERT INTO `suministro` (`id_suministro`, `hora`, `cantidad`, `id_trabajador`, `id_animal`, `id_alimento`) VALUES
(1, '16:00:43', 2, 1, 1, 1),
(2, '11:13:09', 3, 2, 2, 2),
(3, '11:04:09', 5, 3, 3, 3),
(4, '16:00:43', 3, 4, 4, 4),
(5, '13:05:36', 5, 5, 5, 5),
(6, '13:05:36', 6, 6, 6, 6),
(7, '12:05:36', 3, 7, 7, 7),
(8, '10:05:36', 6, 8, 8, 8),
(9, '11:13:09', 5, 9, 9, 9),
(10, '11:04:09', 5, 10, 10, 10),
(11, '13:05:36', 6, 11, 11, 11),
(12, '12:05:36', 2, 12, 12, 12),
(13, '10:05:36', 3, 13, 13, 13),
(14, '11:13:09', 2, 14, 14, 14),
(15, '16:04:09', 5, 15, 15, 15),
(16, '14:30:00', 4, 5, 6, 7);

--
-- Disparadores `suministro`
--
DELIMITER $$
CREATE TRIGGER `suministro_trigger` AFTER UPDATE ON `suministro` FOR EACH ROW BEGIN
    -- Actualizar la tabla "inventario" con la información modificada del suministro
    UPDATE inventario
    SET cantidad = NEW.cantidad,
        hora = NEW.hora
    WHERE id_suministro = OLD.id_suministro;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo`
--

CREATE TABLE `tipo` (
  `id_tipo` int(11) NOT NULL,
  `tipo` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo`
--

INSERT INTO `tipo` (`id_tipo`, `tipo`) VALUES
(1, 'la vaca necesita desparasitante '),
(2, 'la vaca necesita desparasitante '),
(3, 'la vaca necesita desifectacion '),
(4, 'el ganado necesita un plan de alimentacion'),
(5, 'Cumplir con las regulaciones y normas de bienestar  del animal'),
(6, 'necesita vacunacion'),
(7, ' Proporcionar agua limpia y fresca en todo momento'),
(8, 'Proporcionar un alojamiento adecuado y protegido del clima y las condiciones ambientales extremas'),
(9, 'Proporcionar espacio suficiente para que los animales puedan moverse y acostarse cómodamente'),
(10, 'Mantener la higiene y la limpieza en los corrales, establos y áreas de alimentación'),
(11, 'el ganado necesita  Mantener los registros de vacunación y desparasitación actualizados'),
(12, 'Realizar el proceso de castración o esterilización cuando sea necesario'),
(13, 'Controlar el manejo y la manipulación del ganado para minimizar el estrés y el sufrimiento durante la carga y descarga de los animales'),
(14, 'Proporcionar un espacio adecuado para el parto y la cría de los terneros o crías'),
(15, 'Proporcionar un ambiente adecuado para el crecimiento y desarrollo de los animales jóvenes, y controlar el destete para minimizar el estrés.');

--
-- Disparadores `tipo`
--
DELIMITER $$
CREATE TRIGGER `after_tipo_update` AFTER UPDATE ON `tipo` FOR EACH ROW BEGIN
    -- Actualizar la fecha de actualización
    UPDATE tipo SET fecha_actualizacion = CURRENT_TIMESTAMP WHERE id_tipo = NEW.id_tipo;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_alimento`
--

CREATE TABLE `tipo_alimento` (
  `id_tipo_alimento` int(11) NOT NULL,
  `nombre` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_alimento`
--

INSERT INTO `tipo_alimento` (`id_tipo_alimento`, `nombre`) VALUES
(1, 'cebada de primavera'),
(2, 'hierbas silvestres'),
(3, 'heno de alfalfa'),
(4, 'paja de trigo'),
(5, 'silo de maiz de planta entera'),
(6, 'concentrado para engorde'),
(7, 'avena blanca'),
(8, 'maiz harinoso'),
(9, 'soja convencional'),
(10, 'alfalfa comun '),
(11, 'pasto fresco'),
(12, 'caña de azucar'),
(13, 'remolacha'),
(14, 'concentrado de proteina de soja '),
(15, 'silo de hierva');

--
-- Disparadores `tipo_alimento`
--
DELIMITER $$
CREATE TRIGGER `before_tipo_alimento_update` BEFORE UPDATE ON `tipo_alimento` FOR EACH ROW BEGIN
    -- Modificar la descripción
    SET NEW.nombre = CONCAT('Prefijo: ', NEW.nombre);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_animal`
--

CREATE TABLE `tipo_animal` (
  `id_tipo_animal` int(11) NOT NULL,
  `raza` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_animal`
--

INSERT INTO `tipo_animal` (`id_tipo_animal`, `raza`) VALUES
(1, ' vanuno'),
(2, ' obino'),
(3, ' angus'),
(4, ' betted galloway'),
(5, ' branman'),
(6, ' charolais'),
(7, ' dexter'),
(8, ' gelbvieh'),
(9, ' herford'),
(10, ' holstein'),
(11, ' lemosin'),
(12, ' piamontesa'),
(13, ' simmental'),
(14, ' shorthor'),
(15, 'Ganado porcino');

--
-- Disparadores `tipo_animal`
--
DELIMITER $$
CREATE TRIGGER `before_tipo_animal_update` BEFORE UPDATE ON `tipo_animal` FOR EACH ROW BEGIN
    -- Modificar la raza en caso de actualización
    SET NEW.raza = UPPER(NEW.raza);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trabajor`
--

CREATE TABLE `trabajor` (
  `id_trabajador` int(11) NOT NULL,
  `telefono` int(20) DEFAULT NULL,
  `nombre` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `trabajor`
--

INSERT INTO `trabajor` (`id_trabajador`, `telefono`, `nombre`) VALUES
(1, 31211332, ' Manuel'),
(2, 32121133, ' elvira'),
(3, 324223331, ' julian'),
(4, 321212192, ' ramirez'),
(5, 32131221, ' marquez'),
(6, 32345643, 'marcos'),
(7, 31234665, 'alvaro '),
(8, 32311322, ' juli'),
(9, 3124332, ' mariana'),
(10, 31654321, ' paula'),
(11, 31234232, ' carolina'),
(12, 3432231, ' ester'),
(13, 312345674, ' andres'),
(14, 31234232, ' brayan'),
(15, 31211332, ' Laura');

--
-- Disparadores `trabajor`
--
DELIMITER $$
CREATE TRIGGER `trabajador_trigger` AFTER INSERT ON `trabajor` FOR EACH ROW BEGIN
    -- Actualizar la tabla "registro_trabajador" con la información del nuevo trabajador
    INSERT INTO registro_trabajador (id_trabajador, fecha_registro) VALUES (NEW.id_trabajador, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `veterinario`
--

CREATE TABLE `veterinario` (
  `id_veterinario` int(11) NOT NULL,
  `nombre` varchar(20) DEFAULT NULL,
  `telefono` int(30) DEFAULT NULL,
  `especializacion` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `veterinario`
--

INSERT INTO `veterinario` (`id_veterinario`, `nombre`, `telefono`, `especializacion`) VALUES
(1, 'carlos silava', 322323343, 'veterinario zootecnista'),
(2, 'Manuel Rivera', 31892444, 'veterinario zootecnista'),
(3, 'Alejandra Bastidas', 321323343, 'produccion animal'),
(4, 'JUlio Castillo', 324323343, 'mejoramiento animal'),
(5, 'Maria paula', 319323343, 'nutriccion animal'),
(6, 'Ana ESpernza G', 314323343, 'veterinario zootecnista'),
(7, 'David ceron', 321323343, 'mejoramiento animal'),
(8, 'Juliana Diaz', 323323343, 'veterinario zootecnista'),
(9, 'Paula Castillo', 31892444, 'veterinario zootecnista'),
(10, 'Juan Perez', 323323343, 'produccion animal'),
(11, 'Edwin Gonzales', 32873222, 'mejoramiento animal'),
(12, 'Camila Gomez', 319323343, 'nutriccion animal'),
(13, 'Andrea Muñoz', 318323343, 'veterinario zootecnista'),
(14, 'Daniela Ceron', 321323343, 'mejoramiento animal'),
(15, 'Mariana cierra', 325323343, 'veterinario zootecnista'),
(16, 'Pedro Sanchez', 327323343, 'produccion animal');

--
-- Disparadores `veterinario`
--
DELIMITER $$
CREATE TRIGGER `veterinario_trigger` AFTER UPDATE ON `veterinario` FOR EACH ROW BEGIN
    -- Actualizar la tabla "registro_veterinario" con la información modificada del veterinario
    UPDATE registro_veterinario
    SET nombre = NEW.nombre,
        telefono = NEW.telefono,
        especializacion = NEW.especializacion
    WHERE id_veterinario = OLD.id_veterinario;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animal`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animal` (
`peso` int(50)
,`edad` int(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_alimento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_alimento` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`tipo` varchar(150)
,`tipo_alimento` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_chequeo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_chequeo` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`fecha_chequeo` datetime
,`peso_chequeo` varchar(150)
,`recomendaciones` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_procedimiento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_procedimiento` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`fecha_chequeo` datetime
,`tipo_procedimiento` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_suministro`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_suministro` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`hora` time
,`cantidad` int(11)
,`trabajador` varchar(30)
,`tipo_alimento` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_tipo_alimento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_tipo_alimento` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`tipo_recomendado` varchar(150)
,`tipo_alimento` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_animales_veterinario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_animales_veterinario` (
`id_animal` int(11)
,`peso` int(50)
,`edad` int(50)
,`genero` varchar(50)
,`veterinario` varchar(20)
,`especializacion` varchar(30)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_chequeos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_chequeos` (
`id_chequeo` int(11)
,`fecha_chequeo` datetime
,`peso` varchar(150)
,`recomendaciones` varchar(50)
,`veterinario` varchar(20)
,`tipo_procedimiento` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_procedimientos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_procedimientos` (
`id_procedimiento` int(11)
,`fecha_chequeo` datetime
,`tipo` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tipos_animales_alimento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_tipos_animales_alimento` (
`tipo_animal` varchar(150)
,`tipos_alimento` mediumtext
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animal`
--
DROP TABLE IF EXISTS `vista_animal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animal`  AS SELECT `animal`.`peso` AS `peso`, `animal`.`edad` AS `edad` FROM `animal` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_alimento`
--
DROP TABLE IF EXISTS `vista_animales_alimento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_alimento`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `t`.`tipo` AS `tipo`, `al`.`nombre` AS `tipo_alimento` FROM ((`animal` `a` join `tipo` `t` on(`a`.`id_tipo_animal` = `t`.`id_tipo`)) join `alimento` `al` on(`a`.`id_tipo_animal` = `al`.`id_tipo_alimento`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_chequeo`
--
DROP TABLE IF EXISTS `vista_animales_chequeo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_chequeo`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `c`.`fecha_chequeo` AS `fecha_chequeo`, `c`.`peso` AS `peso_chequeo`, `c`.`recomendaciones` AS `recomendaciones` FROM (`animal` `a` join `chequeo` `c` on(`a`.`id_animal` = `c`.`id_animal`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_procedimiento`
--
DROP TABLE IF EXISTS `vista_animales_procedimiento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_procedimiento`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `p`.`fecha_chequeo` AS `fecha_chequeo`, `t`.`tipo` AS `tipo_procedimiento` FROM (((`animal` `a` join `chequeo` `c` on(`a`.`id_animal` = `c`.`id_animal`)) join `procedimiento` `p` on(`c`.`id_procedimiento` = `p`.`id_procedimiento`)) join `tipo` `t` on(`p`.`id_tipo` = `t`.`id_tipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_suministro`
--
DROP TABLE IF EXISTS `vista_animales_suministro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_suministro`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `s`.`hora` AS `hora`, `s`.`cantidad` AS `cantidad`, `t`.`nombre` AS `trabajador`, `al`.`nombre` AS `tipo_alimento` FROM (((`animal` `a` join `suministro` `s` on(`a`.`id_animal` = `s`.`id_animal`)) join `trabajor` `t` on(`s`.`id_trabajador` = `t`.`id_trabajador`)) join `alimento` `al` on(`s`.`id_alimento` = `al`.`id_alimento`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_tipo_alimento`
--
DROP TABLE IF EXISTS `vista_animales_tipo_alimento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_tipo_alimento`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `t`.`tipo` AS `tipo_recomendado`, `al`.`nombre` AS `tipo_alimento` FROM ((`animal` `a` join `tipo` `t` on(`a`.`id_tipo_animal` = `t`.`id_tipo`)) join `alimento` `al` on(`a`.`id_tipo_animal` = `al`.`id_tipo_alimento`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_animales_veterinario`
--
DROP TABLE IF EXISTS `vista_animales_veterinario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_animales_veterinario`  AS SELECT `a`.`id_animal` AS `id_animal`, `a`.`peso` AS `peso`, `a`.`edad` AS `edad`, `a`.`genero` AS `genero`, `v`.`nombre` AS `veterinario`, `v`.`especializacion` AS `especializacion` FROM ((`animal` `a` join `chequeo` `c` on(`a`.`id_animal` = `c`.`id_animal`)) join `veterinario` `v` on(`c`.`id_veterinario` = `v`.`id_veterinario`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_chequeos`
--
DROP TABLE IF EXISTS `vista_chequeos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_chequeos`  AS SELECT `c`.`id_chequeo` AS `id_chequeo`, `c`.`fecha_chequeo` AS `fecha_chequeo`, `c`.`peso` AS `peso`, `c`.`recomendaciones` AS `recomendaciones`, `v`.`nombre` AS `veterinario`, `p`.`id_tipo` AS `tipo_procedimiento` FROM ((`chequeo` `c` join `veterinario` `v` on(`c`.`id_veterinario` = `v`.`id_veterinario`)) join `procedimiento` `p` on(`c`.`id_procedimiento` = `p`.`id_procedimiento`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_procedimientos`
--
DROP TABLE IF EXISTS `vista_procedimientos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_procedimientos`  AS SELECT `p`.`id_procedimiento` AS `id_procedimiento`, `p`.`fecha_chequeo` AS `fecha_chequeo`, `t`.`tipo` AS `tipo` FROM (`procedimiento` `p` join `tipo` `t` on(`p`.`id_tipo` = `t`.`id_tipo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tipos_animales_alimento`
--
DROP TABLE IF EXISTS `vista_tipos_animales_alimento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tipos_animales_alimento`  AS SELECT `t`.`tipo` AS `tipo_animal`, group_concat(`al`.`nombre` separator ', ') AS `tipos_alimento` FROM ((`tipo` `t` join `animal` `a` on(`a`.`id_tipo_animal` = `t`.`id_tipo`)) join `alimento` `al` on(`a`.`id_tipo_animal` = `al`.`id_tipo_alimento`)) GROUP BY `t`.`tipo` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alimento`
--
ALTER TABLE `alimento`
  ADD PRIMARY KEY (`id_alimento`),
  ADD KEY `id_tipo_alimento` (`id_tipo_alimento`);

--
-- Indices de la tabla `animal`
--
ALTER TABLE `animal`
  ADD PRIMARY KEY (`id_animal`),
  ADD KEY `id_tipo_animal` (`id_tipo_animal`);

--
-- Indices de la tabla `chequeo`
--
ALTER TABLE `chequeo`
  ADD PRIMARY KEY (`id_chequeo`),
  ADD KEY `id_veterinario` (`id_veterinario`),
  ADD KEY `id_procedimiento` (`id_procedimiento`),
  ADD KEY `id_animal` (`id_animal`);

--
-- Indices de la tabla `procedimiento`
--
ALTER TABLE `procedimiento`
  ADD PRIMARY KEY (`id_procedimiento`),
  ADD KEY `id_tipo` (`id_tipo`);

--
-- Indices de la tabla `suministro`
--
ALTER TABLE `suministro`
  ADD PRIMARY KEY (`id_suministro`),
  ADD KEY `id_trabajador` (`id_trabajador`),
  ADD KEY `id_animal` (`id_animal`),
  ADD KEY `id_alimento` (`id_alimento`);

--
-- Indices de la tabla `tipo`
--
ALTER TABLE `tipo`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Indices de la tabla `tipo_alimento`
--
ALTER TABLE `tipo_alimento`
  ADD PRIMARY KEY (`id_tipo_alimento`);

--
-- Indices de la tabla `tipo_animal`
--
ALTER TABLE `tipo_animal`
  ADD PRIMARY KEY (`id_tipo_animal`);

--
-- Indices de la tabla `trabajor`
--
ALTER TABLE `trabajor`
  ADD PRIMARY KEY (`id_trabajador`);

--
-- Indices de la tabla `veterinario`
--
ALTER TABLE `veterinario`
  ADD PRIMARY KEY (`id_veterinario`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alimento`
--
ALTER TABLE `alimento`
  ADD CONSTRAINT `alimento_ibfk_1` FOREIGN KEY (`id_tipo_alimento`) REFERENCES `tipo_alimento` (`id_tipo_alimento`);

--
-- Filtros para la tabla `animal`
--
ALTER TABLE `animal`
  ADD CONSTRAINT `animal_ibfk_1` FOREIGN KEY (`id_tipo_animal`) REFERENCES `tipo_animal` (`id_tipo_animal`);

--
-- Filtros para la tabla `chequeo`
--
ALTER TABLE `chequeo`
  ADD CONSTRAINT `chequeo_ibfk_1` FOREIGN KEY (`id_veterinario`) REFERENCES `veterinario` (`id_veterinario`),
  ADD CONSTRAINT `chequeo_ibfk_2` FOREIGN KEY (`id_procedimiento`) REFERENCES `procedimiento` (`id_procedimiento`),
  ADD CONSTRAINT `chequeo_ibfk_3` FOREIGN KEY (`id_animal`) REFERENCES `animal` (`id_animal`);

--
-- Filtros para la tabla `procedimiento`
--
ALTER TABLE `procedimiento`
  ADD CONSTRAINT `procedimiento_ibfk_1` FOREIGN KEY (`id_tipo`) REFERENCES `tipo` (`id_tipo`);

--
-- Filtros para la tabla `suministro`
--
ALTER TABLE `suministro`
  ADD CONSTRAINT `suministro_ibfk_1` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajor` (`id_trabajador`),
  ADD CONSTRAINT `suministro_ibfk_2` FOREIGN KEY (`id_animal`) REFERENCES `animal` (`id_animal`),
  ADD CONSTRAINT `suministro_ibfk_3` FOREIGN KEY (`id_alimento`) REFERENCES `alimento` (`id_alimento`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*DISPARADORES
1—chequeo—------------
Disparador después de la inserción:
Este disparador se activará después de insertar un nuevo registro en la tabla chequeo y actualizará la fecha y hora de la última inserción en la tabla animal.

DELIMITER //

CREATE TRIGGER after_insert_chequeo
AFTER INSERT ON chequeo
FOR EACH ROW
BEGIN
    UPDATE animal
    SET ultima_insercion = NOW()
    WHERE id_animal = NEW.id_animal;
END//

DELIMITER ;
2—----animal—---------------------
Disparador antes de la modificación:
Este disparador se activará antes de modificar un registro en la tabla animal y verificará si el nuevo valor del campo peso es superior al valor máximo permitido. Si es así, se cancelará la modificación y se generará un mensaje de error.
DELIMITER //

CREATE TRIGGER before_update_animal
BEFORE UPDATE ON animal
FOR EACH ROW
BEGIN
    DECLARE max_peso INT;
    SET max_peso = 1000; -- Valor máximo permitido para el peso
    
    IF NEW.peso > max_peso THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El peso excede el límite permitido.';
    END IF;
END//

DELIMITER ;






3------- chequeo—-----------
Disparador después de la eliminación:
Este disparador se activará después de eliminar un registro de la tabla animal y eliminará los registros correspondientes en la tabla chequeo que estén asociados al animal eliminado.
DELIMITER //

CREATE TRIGGER after_delete_animal
AFTER DELETE ON animal
FOR EACH ROW
BEGIN
    DELETE FROM chequeo WHERE id_animal = OLD.id_animal;
END//
DELIMITER ;

—---alimento—------------------------
1-Este disparador se activará después de insertar una nueva fila en la tabla alimento. Actualizará el nombre del tipo de alimento en la tabla tipo_alimento correspondiente al id_tipo alimento recién insertado
DELIMITER //
CREATE TRIGGER trigger_actualizar_tipo_alimento AFTER INSERT ON alimento
FOR EACH ROW
BEGIN
    UPDATE tipo_alimento SET nombre = NEW.nombre WHERE id_tipo_alimento = NEW.id_tipo_alimento;
END //
DELIMITER ;
—------procedimiento—-------------------------------
En el ejemplo anterior, se crea un disparador llamado trigger_actualizar_alimento que se ejecutará después de insertar una nueva fila en la tabla de alimentos. En este caso, el disparador realiza una acción de inserción en la tabla log_alimento, que podría ser utilizada para rastrear los cambios o realizar algún tipo de registro.

CREATE TRIGGER trigger_actualizar_alimento AFTER INSERT ON alimento FOR EACH ROW BEGIN INSERT INTO log_alimento (nombre_alimento, fecha) VALUES (NEW.nombre, NOW()); END;
—---------suministros—--------------
En este ejemplo, el disparador se activa después de una operación de actualización (UPDATE) en la tabla "suministro". Dentro del bloque BEGIN...END, se utiliza la instrucción UPDATE para actualizar la tabla "inventario" con la información modificada del suministro.
CREATE TRIGGER suministro_trigger AFTER UPDATE ON suministro FOR EACH ROW BEGIN -- Actualizar la tabla "inventario" con la información modificada del suministro UPDATE inventario SET cantidad = NEW.cantidad, hora = NEW.hora WHERE id_suministro = OLD.id_suministro; END;





—----------------tipo—------------------------------------------------
En este ejemplo, el disparador se activará después de cualquier actualización en la tabla tipo. Utiliza la función CURRENT_TIMESTAMP para obtener la fecha y hora actuales y actualiza el campo fecha_actualizacion de la fila afectada por la actualización.

CREATE TRIGGER after_tipo_update AFTER UPDATE ON tipo FOR EACH ROW BEGIN -- Actualizar la fecha de actualización UPDATE tipo SET fecha_actualizacion = CURRENT_TIMESTAMP WHERE id_tipo = NEW.id_tipo; END;

—-------------------tipo alimento—--------------------------------
En este ejemplo, el disparador se activará antes de cualquier modificación en la tabla tipo_alimento. Utiliza la función CONCAT para agregar el prefijo "Prefijo: " al valor de nombre que se está intentando modificar.

CREATE TRIGGER before_tipo_alimento_update BEFORE UPDATE ON tipo_alimento FOR EACH ROW BEGIN -- Modificar la descripción SET NEW.nombre = CONCAT('Prefijo: ', NEW.nombre); END;

—----------tipo animal—------------------------------------
en este ejemplo, se han definido dos disparadores. El primero, before_tipo_animal_update, se activa antes de cualquier modificación en la tabla tipo_animal y modifica automáticamente el valor del campo descripcion en caso de actualización. El segundo, before_tipo_animal_delete, se activa antes de eliminar una fila de la tabla y también modifica el valor de descripcion, en este caso en la fila que está siendo eliminada.
DELIMITER //

CREATE TRIGGER before_tipo_animal_update
BEFORE UPDATE ON tipo_animal
FOR EACH ROW
BEGIN
    -- Modificar la raza en caso de actualización
    SET NEW.raza = UPPER(NEW.raza);
END//

CREATE TRIGGER before_tipo_animal_delete
BEFORE DELETE ON tipo_animal
FOR EACH ROW
BEGIN
    -- Modificar la raza en caso de eliminación
    SET OLD.raza = UPPER(OLD.raza);
END//

DELIMITER ;


—-----------------trabajador—-------------------------------
En este ejemplo, se utiliza la instrucción INSERT INTO para insertar un nuevo registro en la tabla "registro_trabajador". Se captura el ID del nuevo trabajador (NEW.id_trabajador) y se utiliza la función NOW() para obtener la fecha y hora actual y registrarla en el campo "fecha_registro" de la tabla "registro_trabajador"

CREATE TRIGGER trabajador_trigger AFTER INSERT ON trabajor FOR EACH ROW BEGIN -- Actualizar la tabla "registro_trabajador" con la información del nuevo trabajador INSERT INTO registro_trabajador (id_trabajador, fecha_registro) VALUES (NEW.id_trabajador, NOW()); END;


—---------------veterinario—------------------------------------------
En este ejemplo, el disparador se activa después de una operación de actualización (UPDATE) en la tabla "veterinario". Dentro del bloque BEGIN...END, se utiliza la instrucción UPDATE para actualizar la tabla "registro_veterinario" con la información modificada del veterinario.
CREATE TRIGGER veterinario_trigger AFTER UPDATE ON veterinario FOR EACH ROW BEGIN -- Actualizar la tabla "registro_veterinario" con la información modificada del veterinario UPDATE registro_veterinario SET nombre = NEW.nombre, telefono = NEW.telefono, especializacion = NEW.especializacion WHERE id_veterinario = OLD.id_veterinario; END;










*Crear 10 vistas con  su respectivo enunciado 
1----"Crear una vista llamada vista_alimento que muestra los campos nombre y precio de la tabla productos. Luego, realizar una consulta utilizando la vista vista_alimento mediante la siguiente instrucción:"
SELECT * FROM vista_alimento;Esta consulta mostrará todos los registros y campos de la vista vista_alimento, que a su vez obtiene los datos de la tabla productos.
-- Crear la vista CREATE VIEW vista_animal AS SELECT peso, edad FROM animal;
2----Vista de los animales y su tipo de alimento:
CREATE VIEW vista_animales_alimento AS
SELECT a.id_animal, a.peso, a.edad, a.genero, t.tipo AS tipo, al.nombre AS tipo_alimento
FROM animal a
INNER JOIN tipo t ON a.id_tipo_animal = t.id_tipo
INNER JOIN alimento al ON a.id_tipo_animal = al.id_tipo_alimento;
3----Vista de los animales y sus chequeos veterinarios:
CREATE VIEW vista_animales_chequeo AS SELECT a.id_animal, a.peso, a.edad, a.genero, c.fecha_chequeo, c.peso AS peso_chequeo, c.recomendaciones FROM animal a INNER JOIN chequeo c ON a.id_animal = c.id_animal;
4----Vista de los animales y los procedimientos realizados:
CREATE VIEW vista_animales_procedimiento AS SELECT a.id_animal, a.peso, a.edad, a.genero, p.fecha_chequeo, t.tipo AS tipo_procedimiento FROM animal a INNER JOIN chequeo c ON a.id_animal = c.id_animal INNER JOIN procedimiento p ON c.id_procedimiento = p.id_procedimiento INNER JOIN tipo t ON p.id_tipo = t.id_tipo;
5---Vista de los animales y los trabajadores encargados de suministrar alimento:
CREATE VIEW vista_animales_suministro AS SELECT a.id_animal, a.peso, a.edad, a.genero, s.hora, s.cantidad, t.nombre AS trabajador, al.nombre AS tipo_alimento FROM animal a INNER JOIN suministro s ON a.id_animal = s.id_animal INNER JOIN trabajor t ON s.id_trabajador = t.id_trabajador INNER JOIN alimento al ON s.id_alimento = al.id_alimento;
6-----Vista de los animales y los tipos de alimentación recomendados:
CREATE VIEW vista_animales_tipo_alimento AS SELECT a.id_animal, a.peso, a.edad, a.genero, t.tipo AS tipo_recomendado, al.nombre AS tipo_alimento FROM animal a INNER JOIN tipo t ON a.id_tipo_animal = t.id_tipo INNER JOIN alimento al ON a.id_tipo_animal = al.id_tipo_alimento;
7-----Vista de los animales y sus veterinarios asignados:
CREATE VIEW vista_animales_veterinario AS
SELECT a.id_animal, a.peso, a.edad, a.genero, v.nombre AS veterinario, v.especializacion
FROM animal a
INNER JOIN chequeo c ON a.id_animal = c.id_animal
INNER JOIN veterinario v ON c.id_veterinario = v.id_veterinario;
8-----Vista de los tipos de animales y sus respectivos alimentos:
CREATE VIEW vista_tipos_animales_alimento AS SELECT t.tipo AS tipo_animal, GROUP_CONCAT(al.nombre SEPARATOR ', ') AS tipos_alimento FROM tipo t INNER JOIN animal a ON a.id_tipo_animal = t.id_tipo INNER JOIN alimento al ON a.id_tipo_animal = al.id_tipo_alimento GROUP BY t.tipo;
9----vista de los procedimientos
CREATE VIEW vista_procedimientos AS
SELECT p.id_procedimiento, p.fecha_chequeo, t.tipo
FROM procedimiento p
INNER JOIN tipo t ON p.id_tipo = t.id_tipo;
10-----La vista "vista_chequeos" muestra información resumida de los chequeos realizados, incluyendo el ID del chequeo, la fecha, el peso, las recomendaciones, el nombre del veterinario y el ID del tipo de procedimiento asociado.
CREATE VIEW vista_chequeos AS SELECT c.id_chequeo, c.fecha_chequeo, c.peso, c.recomendaciones, v.nombre AS veterinario, p.id_tipo AS tipo_procedimiento FROM chequeo c INNER JOIN veterinario v ON c.id_veterinario = v.id_veterinario INNER JOIN procedimiento p ON c.id_procedimiento = p.id_procedimiento;

funciones:

esta función calcula el promedio de pesos de todos los animales
DELIMITER //

CREATE FUNCTION calcularPromedioPesoTipoAnimal(idTipoAnimal INT)
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE promedio DECIMAL(10,2);
  
  SELECT AVG(peso) INTO promedio
  FROM animal
  WHERE id_tipo_animal = idTipoAnimal;
  
  RETURN promedio;
END //

DELIMITER ;

-llama la función; 
SELECT calcularPromedioPesoTipoAnimal(1);




esta función llama la cantidad de tipos de animales que hay

DELIMITER //

CREATE FUNCTION obtenerCantidadAnimalesTipo(idTipoAnimal INT)
RETURNS INT
BEGIN
  DECLARE cantidad INT;
  
  SELECT COUNT(*) INTO cantidad
  FROM animal
  WHERE id_tipo_animal = idTipoAnimal;
  
  RETURN cantidad;
END //

DELIMITER ;

-llama la función
SELECT obtenerCantidadAnimalesTipo(1);
-3 
Este código crea una función llamada obtenerPromedioEdadAnimalesTipo que calcula el promedio de edad de los animales de un determinado tipo

DELIMITER //

CREATE FUNCTION obtenerPromedioEdadAnimalesTipo(idTipoAnimal INT)
RETURNS FLOAT
BEGIN
  DECLARE promedioEdad FLOAT;
  
  SELECT AVG(edad) INTO promedioEdad
  FROM animal
  WHERE id_tipo_animal = idTipoAnimal;
  
  RETURN promedioEdad;
END //

DELIMITER ;

SELECTobtenerPromedioEdadAnimalesTipo(1);




4 Este código crea una función llamada obtenerCantidadAnimalesPorGenero que cuenta la cantidad de animales de un determinado género.

DELIMITER //

CREATE FUNCTION obtenerCantidadAnimalesPorGenero(genero VARCHAR(10))
RETURNS INT
BEGIN
  DECLARE cantidad INT;
  
  SELECT COUNT(*) INTO cantidad
  FROM animal
  WHERE genero = genero;
  
  RETURN cantidad;
END //

DELIMITER ;

SELECT  obtenerCantidadAnimalesPorGenero(1);



5-
DELIMITER //

CREATE FUNCTION modificar_tipo(
    p_id_tipo INT,
    p_nuevo_tipo VARCHAR(150)
)
RETURNS INT
BEGIN
    DECLARE rows_affected INT;

    UPDATE tipo
    SET tipo = p_nuevo_tipo
    WHERE id_tipo = p_id_tipo;

    SET rows_affected = ROW_COUNT();

    RETURN rows_affected;
END //

DELIMITER ;


SELECT modificar_tipo(1, 'Nuevo tipo de vaca');

6-
DELIMITER // CREATE FUNCTION insertarVeterinario ( id INT, nombre VARCHAR(20), telefono INT, especializacion VARCHAR(30) ) RETURNS INT BEGIN DECLARE numRows INT; INSERT INTO veterinario (id_veterinario, nombre, telefono, especializacion) VALUES (id, nombre, telefono, especializacion); SET numRows = ROW_COUNT(); RETURN numRows; END // DELIMITER ;

SELECT insertarVeterinario(16, 'Pedro Sanchez', 327323343, 'produccion animal');

7-
DELIMITER //

CREATE FUNCTION insertar_suministro(
  p_id_suministro INT,
  p_hora TIME,
  p_cantidad INT,
  p_id_trabajador INT,
  p_id_animal INT,
  p_id_alimento INT
)
RETURNS INT
BEGIN
  INSERT INTO suministro (id_suministro, hora, cantidad, id_trabajador, id_animal, id_alimento)
  VALUES (p_id_suministro, p_hora, p_cantidad, p_id_trabajador, p_id_animal, p_id_alimento);
  
  RETURN LAST_INSERT_ID();
END //

DELIMITER ;
SELECT insertar_suministro(16, '14:30:00', 4, 5, 6, 7);
8-
DELIMITER //

CREATE FUNCTION modificar_procedimiento(
  p_id_procedimiento INT,
  p_fecha_chequeo DATETIME,
  p_id_tipo INT
)
RETURNS BOOLEAN
BEGIN
  DECLARE rows_affected INT;

  UPDATE procedimiento
  SET fecha_chequeo = p_fecha_chequeo,
      id_tipo = p_id_tipo
  WHERE id_procedimiento = p_id_procedimiento;

  SET rows_affected = ROW_COUNT();

  IF rows_affected > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //

DELIMITER ;
SELECT modificar_procedimiento(1, '2023-05-10 09:00:00', 3);

9
DELIMITER //

CREATE FUNCTION modificar_chequeo(
  p_id_chequeo INT,
  p_fecha_chequeo DATETIME,
  p_peso VARCHAR(150),
  p_recomendaciones VARCHAR(50),
  p_id_veterinario INT,
  p_id_procedimiento INT,
  p_id_animal INT
)
RETURNS BOOLEAN
BEGIN
  DECLARE rows_affected INT;

  UPDATE chequeo
  SET fecha_chequeo = p_fecha_chequeo,
      peso = p_peso,
      recomendaciones = p_recomendaciones,
      id_veterinario = p_id_veterinario,
      id_procedimiento = p_id_procedimiento,
      id_animal = p_id_animal
  WHERE id_chequeo = p_id_chequeo;

  SET rows_affected = ROW_COUNT();

  IF rows_affected > 0 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //

DELIMITER ;

SELECT modificar_chequeo(1, '2023-05-10 09:00:00', '550', 'Revisión adicional requerida', 1, 1, 1);



10)

DELIMITER //

CREATE FUNCTION modificar_animal(
  animal_id INT,
  new_peso INT,
  new_edad INT,
  new_genero VARCHAR(50),
  new_tipo_animal INT
)
RETURNS VARCHAR(50)
BEGIN
  DECLARE message VARCHAR(50);

  UPDATE `animal`
  SET
    `peso` = new_peso,
    `edad` = new_edad,
    `genero` = new_genero,
    `id_tipo_animal` = new_tipo_animal
  WHERE
    `id_animal` = animal_id;

  IF ROW_COUNT() > 0 THEN
    SET message = 'Animal actualizado correctamente.';
  ELSE
    SET message = 'No se encontró ningún animal con el ID especificado.';
  END IF;

  RETURN message;
END //

DELIMITER ;

SELECT modificar_animal(1, 350, 3, 'Macho', 2);
*/
