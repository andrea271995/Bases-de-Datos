-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Libros
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Libros
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Libros` DEFAULT CHARACTER SET utf8 ;
USE `Libros` ;

-- -----------------------------------------------------
-- Table `Libros`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`detalle_pedido` (
  `id_detalle_pedido` INT NOT NULL,
  `id_pedido` INT NULL,
  `id_libro` INT NULL,
  `cantidad` INT NULL,
  PRIMARY KEY (`id_detalle_pedido`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Libros`.`libros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`libros` (
  `id_libros` INT NOT NULL,
  `titulo` VARCHAR(45) NULL,
  `autor` VARCHAR(45) NULL,
  `precio` DECIMAL(10) NULL,
  `cantidad_stock` VARCHAR(45) NULL,
  `detalle_pedido_id_detalle_pedido` INT NOT NULL,
  PRIMARY KEY (`id_libros`, `detalle_pedido_id_detalle_pedido`),
  INDEX `fk_libros_detalle_pedido1_idx` (`detalle_pedido_id_detalle_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_libros_detalle_pedido1`
    FOREIGN KEY (`detalle_pedido_id_detalle_pedido`)
    REFERENCES `Libros`.`detalle_pedido` (`id_detalle_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Libros`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`pedidos` (
  `id_pedidos` INT NOT NULL,
  `id_clientes` INT NULL,
  `fecha_pedido` DATETIME NULL,
  `detalle_pedido_id_detalle_pedido` INT NOT NULL,
  `detalle_pedido_id_detalle_pedido1` INT NOT NULL,
  PRIMARY KEY (`id_pedidos`, `detalle_pedido_id_detalle_pedido`, `detalle_pedido_id_detalle_pedido1`),
  INDEX `fk_pedidos_detalle_pedido1_idx` (`detalle_pedido_id_detalle_pedido1` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_detalle_pedido1`
    FOREIGN KEY (`detalle_pedido_id_detalle_pedido1`)
    REFERENCES `Libros`.`detalle_pedido` (`id_detalle_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Libros`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`clientes` (
  `id_clientes` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  `pedidos_id_pedidos` INT NOT NULL,
  PRIMARY KEY (`id_clientes`, `pedidos_id_pedidos`),
  INDEX `fk_clientes_pedidos1_idx` (`pedidos_id_pedidos` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_pedidos1`
    FOREIGN KEY (`pedidos_id_pedidos`)
    REFERENCES `Libros`.`pedidos` (`id_pedidos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SELECT libros.titulo, libros.autor, SUM(detalle_pedido.cantidad) as total_vendido
FROM libros
INNER JOIN detalle_pedido ON detalle_pedido.id_libro = libros.id_libros
GROUP BY libros.titulo, libros.autor
ORDER BY total_vendido DESC
LIMIT 10;

SELECT clientes.nombre, clientes.apellido, SUM(detalle_pedido.cantidad) as total_comprado
FROM detalle_pedido
INNER JOIN pedidos ON detalle_pedido.id_pedido = pedidos.id_pedidos
INNER JOIN clientes ON pedidos.id_clientes = clientes.id_clientes
GROUP BY clientes.nombre, clientes.apellido
ORDER BY total_comprado DESC
LIMIT 5;

SELECT libros.titulo, libros.autor, SUM(detalle_pedido.cantidad*libros.precio) as ventas_totales   #Primero seleccionamos la tabla y el atributo que queremos saber
FROM detalle_pedido                                                                                #Desde que tabla
INNER JOIN libros ON detalle_pedido.id_libro = libros.id_libros                                    #Juntamos la tabla, ON = porque atributo en comun las unimos
WHERE libros.titulo = '1984' AND libros.autor = 'George Orwell'                                    #Donde de la tabla y el atributo que queremos y el autor
GROUP BY libros.titulo, libros.autor;                                                              #Lo ordenas por el titulo y el autor.

UPDATE libros
SET cantidad_stock = 20
WHERE cantidad_stock < 10;   #Da error porque no tenemos datos.


