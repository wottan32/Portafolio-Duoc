SET SERVEROUTPUT ON;
-----------------------------------------------------USUARIO-------------------------------------------------------------------------------
--PROCEDIMIENTO ALMACENADO PR_REGISTRAR_USUARIO
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_USUARIO
(p_rut IN USUARIOS.RUT%TYPE,p_digito_verificador IN USUARIOS.DIGITO_VERIFICADOR%TYPE,p_clave IN USUARIOS.CLAVE%TYPE,p_nombre IN USUARIOS.NOMBRES%TYPE
,p_apellido_paterno IN USUARIOS.APELLIDO_PATERNO%TYPE, p_apellido_materno IN USUARIOS.APELLIDO_MATERNO%TYPE,p_direccion IN USUARIOS.DIRECCION%TYPE,
p_comuna IN USUARIOS.COMUNA%TYPE,p_telefono IN USUARIOS.TELEFONO%TYPE,p_email IN USUARIOS.EMAIL%TYPE, p_dd_legales IN USUARIOS.DD_LEGALES%TYPE, 
p_dd_administrativos IN USUARIOS.DD_ADMINISTRATIVOS%TYPE,p_fecha_contrato IN USUARIOS.FECHA_CONTRATO%TYPE, p_id_perfil IN USUARIOS.ID_PERFIL%TYPE, p_id_cargo IN USUARIOS.ID_CARGO%TYPE,p_id_departamento IN USUARIOS.ID_DEPARTAMENTO%TYPE, p_resultado OUT VARCHAR2 )
IS
BEGIN
INSERT INTO USUARIOS(RUT,DIGITO_VERIFICADOR,CLAVE,NOMBRES,APELLIDO_PATERNO,APELLIDO_MATERNO,DIRECCION,COMUNA,TELEFONO,EMAIL,DD_LEGALES,DD_ADMINISTRATIVOS,
FECHA_CONTRATO,ID_PERFIL,ID_CARGO,ID_DEPARTAMENTO)
VALUES(p_rut,p_digito_verificador,p_clave,p_nombre,p_apellido_paterno,p_apellido_materno,p_direccion,p_comuna,p_telefono,p_email,p_dd_legales,p_dd_administrativos,
p_fecha_contrato,p_id_perfil,p_id_cargo,p_id_departamento);
p_resultado := 'Usuario: ' || p_nombre || ' ' || p_apellido_paterno || ' Registrado' ;
END PR_REGISTRAR_USUARIO;


--PROCEDIMIENTO ALMACENADO PR_EDITAR_USUARIO
CREATE OR REPLACE PROCEDURE PR_EDITAR_USUARIO
(p_rut IN USUARIOS.RUT%TYPE,p_nombre IN USUARIOS.NOMBRES%TYPE
,p_apellido_paterno IN USUARIOS.APELLIDO_PATERNO%TYPE, p_apellido_materno IN USUARIOS.APELLIDO_MATERNO%TYPE,p_direccion IN USUARIOS.DIRECCION%TYPE,p_comuna IN USUARIOS.COMUNA%TYPE,p_telefono IN USUARIOS.TELEFONO%TYPE,
p_email IN USUARIOS.EMAIL%TYPE, p_dd_legales IN USUARIOS.DD_LEGALES%TYPE, p_dd_administrativos IN USUARIOS.DD_ADMINISTRATIVOS%TYPE,
p_fecha_contrato IN USUARIOS.FECHA_CONTRATO%TYPE,p_id_perfil IN USUARIOS.ID_PERFIL%TYPE, p_id_cargo IN USUARIOS.ID_CARGO%TYPE,
p_id_departamento IN USUARIOS.ID_DEPARTAMENTO%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
UPDATE USUARIOS
SET 
NOMBRES = p_nombre,
APELLIDO_PATERNO = p_apellido_paterno,
APELLIDO_MATERNO = p_apellido_materno,
DIRECCION = p_direccion,
COMUNA = p_comuna,
TELEFONO = p_telefono,
EMAIL = p_email,
DD_LEGALES = p_dd_legales,
DD_ADMINISTRATIVOS = p_dd_administrativos,
FECHA_CONTRATO = p_fecha_contrato,
ID_PERFIL = p_id_perfil,
ID_CARGO = p_id_cargo,
ID_DEPARTAMENTO = p_id_departamento
WHERE RUT LIKE p_rut;
p_resultado := 'Usuario Rut : ' || p_rut || ' modificado';
END PR_EDITAR_USUARIO;  

--PROCEDIMIENTO ALMACENADO PR_BUSCAR_USUARIO
CREATE OR REPLACE PROCEDURE PR_BUSCAR_USUARIO
(p_rut IN USUARIOS.RUT%TYPE,
p_digito_verificador OUT USUARIOS.DIGITO_VERIFICADOR%TYPE,
p_clave OUT USUARIOS.CLAVE%TYPE,
p_nombre OUT USUARIOS.NOMBRES%TYPE
,p_apellido_paterno OUT USUARIOS.APELLIDO_PATERNO%TYPE,
 p_apellido_materno OUT USUARIOS.APELLIDO_MATERNO%TYPE,
p_direccion OUT USUARIOS.DIRECCION%TYPE,
p_comuna OUT USUARIOS.COMUNA%TYPE,
p_telefono OUT USUARIOS.TELEFONO%TYPE,
p_email OUT USUARIOS.EMAIL%TYPE, 
p_dd_legales OUT USUARIOS.DD_LEGALES%TYPE,
 p_dd_administrativos OUT USUARIOS.DD_ADMINISTRATIVOS%TYPE,
p_fecha_contrato OUT USUARIOS.FECHA_CONTRATO%TYPE,
 p_id_perfil OUT USUARIOS.ID_PERFIL%TYPE,
 p_id_cargo OUT USUARIOS.ID_CARGO%TYPE,
p_id_departamento OUT USUARIOS.ID_DEPARTAMENTO%TYPE,
 p_resultado OUT VARCHAR2)
IS
BEGIN
SELECT DIGITO_VERIFICADOR , CLAVE , NOMBRES , APELLIDO_PATERNO , APELLIDO_MATERNO ,DIRECCION,COMUNA, TELEFONO , EMAIL , DD_LEGALES , DD_ADMINISTRATIVOS , FECHA_CONTRATO
,  ID_PERFIL , ID_CARGO , ID_DEPARTAMENTO
INTO p_digito_verificador , p_clave , p_nombre , p_apellido_paterno , p_apellido_materno ,p_direccion , p_comuna, p_telefono , p_email , p_dd_legales , p_dd_administrativos,
p_fecha_contrato , p_id_perfil , p_id_cargo  , p_id_departamento
FROM USUARIOS
WHERE RUT LIKE p_rut;
p_resultado := 'Datos encontrados';
END PR_BUSCAR_USUARIO;

--PROCEDIMIENTO ALMACENAD PR_MOSTRAR_USUARIO
--CABEZA DEL PAQUETE Y PROCEDIMIENTO 
CREATE OR REPLACE PACKAGE MOSTRAR_USUARIO IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_USUARIO (v_cursor OUT vCursor);
END MOSTRAR_USUARIO;

/ --ESTO SEPARA LA CABEZA CON EL CUERPO, NO QUITARLA, DARA ERROR Y TODO SE DERRUMBARA

--CUERPO DEL PAQUETE Y EL PROCEDIMIENTO
CREATE OR REPLACE PACKAGE BODY MOSTRAR_USUARIO IS
PROCEDURE  PR_MOSTRAR_USUARIO(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT RUT , DIGITO_VERIFICADOR , CLAVE , NOMBRES , APELLIDO_PATERNO , APELLIDO_MATERNO , DIRECCION , COMUNA, TELEFONO , EMAIL , DD_LEGALES ,
           DD_ADMINISTRATIVOS , FECHA_CONTRATO , U.ID_PERFIL , U.ID_CARGO , U.ID_DEPARTAMENTO ,
           PERFIL , CARGO , DEPARTAMENTO
    FROM USUARIOS U JOIN USUARIO_PERFILES UUP
    ON(U.ID_PERFIL = UUP.ID_PERFIL)
    JOIN USUARIO_CARGOS UC
    ON(U.ID_CARGO = UC.ID_CARGO)
    JOIN USUARIO_DEPARTAMENTOS UD
    ON(U.ID_DEPARTAMENTO = UD.ID_DEPARTAMENTO)
    ORDER BY RUT DESC , NOMBRES DESC;
END  PR_MOSTRAR_USUARIO;
END MOSTRAR_USUARIO;

--PROCEDIMIENTOS PARA CARGAR LOS DROP DOWN LIST DEL MANTENERDOR USUARIO
CREATE OR REPLACE PACKAGE MOSTRAR_USUARIO_CARGO IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_USUARIO_CARGO (v_cursor OUT vCursor);
END MOSTRAR_USUARIO_CARGO;
/
CREATE OR REPLACE PACKAGE BODY MOSTRAR_USUARIO_CARGO IS
PROCEDURE  PR_MOSTRAR_USUARIO_CARGO(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT DISTINCT CARGO
    FROM USUARIO_CARGOS
    ORDER BY CARGO DESC;
END  PR_MOSTRAR_USUARIO_CARGO;
END MOSTRAR_USUARIO_CARGO;

--PROCEDIMIENTOS PARA CARGAR LOS DROP DOWN LIST DEL MANTENERDOR USUARIO
CREATE OR REPLACE PACKAGE MOSTRAR_USUARIO_PERFIL IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_USUARIO_PERFIL (v_cursor OUT vCursor);
END MOSTRAR_USUARIO_PERFIL;
/
CREATE OR REPLACE PACKAGE BODY MOSTRAR_USUARIO_PERFIL IS
PROCEDURE  PR_MOSTRAR_USUARIO_PERFIL(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT DISTINCT PERFIL
    FROM  USUARIO_PERFILES 
    ORDER BY PERFIL DESC;
END  PR_MOSTRAR_USUARIO_PERFIL;
END MOSTRAR_USUARIO_PERFIL;

--PROCEDIMIENTOS PARA CARGAR LOS DROP DOWN LIST DEL MANTENERDOR USUARIO
CREATE OR REPLACE PACKAGE MOSTRAR_USUARIO_DEP IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_USUARIO_DEP (v_cursor OUT vCursor);
END MOSTRAR_USUARIO_DEP;
/
CREATE OR REPLACE PACKAGE BODY MOSTRAR_USUARIO_DEP IS
PROCEDURE  PR_MOSTRAR_USUARIO_DEP(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT DISTINCT DEPARTAMENTO
    FROM  USUARIO_DEPARTAMENTOS 
    ORDER BY DEPARTAMENTO DESC;
END  PR_MOSTRAR_USUARIO_DEP;
END MOSTRAR_USUARIO_DEP;

--PROCEDIMIENTO PARA OBTENER EL ID DEL PERFIL DEL USUARIO
CREATE OR REPLACE PROCEDURE PR_OBTENER_ID_PERFIL (p_perfil IN USUARIO_PERFILES.PERFIL%TYPE, p_id_perfil OUT USUARIO_PERFILES.ID_PERFIL%TYPE)
IS
BEGIN
SELECT ID_PERFIL
INTO p_id_perfil
FROM USUARIO_PERFILES
WHERE PERFIL LIKE p_perfil AND ROWNUM = 1;
END PR_OBTENER_ID_PERFIL;

--PROCEDIMIENTO PARA OBTENER EL ID DEL CARGO DEL USUARIO
CREATE OR REPLACE PROCEDURE PR_OBTENER_ID_CARGO (p_cargo IN USUARIO_CARGOS.CARGO%TYPE, p_id_cargo OUT USUARIO_CARGOS.ID_CARGO%TYPE)
IS
BEGIN
SELECT ID_CARGO
INTO p_id_cargo
FROM USUARIO_CARGOS
WHERE CARGO LIKE p_cargo AND ROWNUM = 1;
END PR_OBTENER_ID_CARGO;

--PROCEDIMIENTO PARA OBTENER EL ID DEL DEPARTAMENTO DEL USUARIO
CREATE OR REPLACE PROCEDURE PR_OBTENER_ID_DEP (p_departamento IN USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE, p_id_departamento OUT USUARIO_DEPARTAMENTOS.ID_DEPARTAMENTO%TYPE)
IS
BEGIN
SELECT ID_DEPARTAMENTO
INTO p_id_departamento
FROM USUARIO_DEPARTAMENTOS
WHERE DEPARTAMENTO LIKE p_departamento AND ROWNUM = 1;
END PR_OBTENER_ID_DEP;


--PROCEDIMIENTO PARA OBTENER EL CARGO EN BASE A LA ID OBTENIDA
CREATE OR REPLACE PROCEDURE PR_OBTENER_CARGO_POR_ID(p_id_cargo IN USUARIO_CARGOS.ID_CARGO%TYPE,p_cargo OUT USUARIO_CARGOS.CARGO%TYPE)
IS
BEGIN
SELECT CARGO
INTO p_cargo
FROM USUARIO_CARGOS
WHERE ID_CARGO LIKE p_id_cargo AND ROWNUM = 1;
END PR_OBTENER_CARGO_POR_ID;

--PROCEDIMIENTO PARA OBTENER EL PERFIL EN BASE A LA ID OBTENIDA
CREATE OR REPLACE PROCEDURE PR_OBTENER_PERFIL_POR_ID(p_id_perfil IN USUARIO_PERFILES.ID_PERFIL%TYPE,p_perfil OUT USUARIO_PERFILES.PERFIL%TYPE)
IS
BEGIN
SELECT PERFIL
INTO p_perfil
FROM USUARIO_PERFILES
WHERE ID_PERFIL LIKE p_id_perfil AND ROWNUM = 1;
END PR_OBTENER_PERFIL_POR_ID;

--PROCEDIMIENTO PARA OBTENER EL DEPARTAMENTO  EN BASE LA ID OBTENIDA
CREATE OR REPLACE PROCEDURE PR_OBTENER_DEP_POR_ID(p_id_departamento IN USUARIO_DEPARTAMENTOS.ID_DEPARTAMENTO%TYPE,
p_departamento OUT USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE)
IS
BEGIN
SELECT DEPARTAMENTO
INTO p_departamento
FROM USUARIO_DEPARTAMENTOS
WHERE ID_DEPARTAMENTO LIKE p_id_departamento AND ROWNUM = 1;
END PR_OBTENER_DEP_POR_ID;
---------------------------------------------------- PERMISO MOTIVO--------------------------------------------------------------------------
--PROCEDIMIENTO ALMACENADO PR_REGISTRAR_MOTIVO
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_MOTIVO_PERMISO
(p_motivo IN PERMISO_MOTIVOS.MOTIVO%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
INSERT INTO PERMISO_MOTIVOS(id_motivo,motivo)
VALUES(SEQ_PERMISO_MOTIVOS.nextval,p_motivo);
p_resultado := 'Motivo Registrado: ' || p_motivo;
END PR_REGISTRAR_MOTIVO_PERMISO;

--PROCEDIMIENTO ALMACENADO PR_EDITAR_PERMISO_MOTIVO
CREATE OR REPLACE PROCEDURE PR_EDITAR_PERMISO_MOTIVO
(p_id_motivo IN PERMISO_MOTIVOS.ID_MOTIVO%TYPE,p_motivo IN PERMISO_MOTIVOS.MOTIVO%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
UPDATE PERMISO_MOTIVOS
SET MOTIVO = p_motivo
WHERE ID_MOTIVO LIKE p_id_motivo;
p_resultado := 'Motivo ' || p_motivo || ' modificado';
END PR_EDITAR_PERMISO_MOTIVO;  

--PROCEDIMIENTO ALMACENADO PR_BUSCAR_USUARIO_DEP
CREATE OR REPLACE PROCEDURE PR_BUSCAR_PERMISO_MOTIVO
(p_id_motivo IN PERMISO_MOTIVOS.ID_MOTIVO%TYPE,p_motivo OUT PERMISO_MOTIVOS.MOTIVO%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
SELECT MOTIVO 
INTO p_motivo
FROM PERMISO_MOTIVOS
WHERE ID_MOTIVO LIKE p_id_motivo;
p_resultado := 'Datos encontrados';
END PR_BUSCAR_PERMISO_MOTIVO;

--PROCEDIMIENTO MOSTRAR MOTIVOS
--CABEZA DEL PAQUETE Y PROCEDIMIENTO 
CREATE OR REPLACE PACKAGE MOSTRAR_PERMISO_MOTIVO IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_PERMISO_MOTIVO (v_cursor OUT vCursor);
END MOSTRAR_PERMISO_MOTIVO;

/ --ESTO SEPARA LA CABEZA CON EL CUERPO, NO QUITARLA, DARA ERROR Y TODO SE DERRUMBARA

--CUERPO DEL PAQUETE Y EL PROCEDIMIENTO
CREATE OR REPLACE PACKAGE BODY MOSTRAR_PERMISO_MOTIVO IS
PROCEDURE  PR_MOSTRAR_PERMISO_MOTIVO(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT ID_MOTIVO , MOTIVO
    FROM PERMISO_MOTIVOS
    ORDER BY MOTIVO DESC;
END  PR_MOSTRAR_PERMISO_MOTIVO;
END MOSTRAR_PERMISO_MOTIVO;

--------------------------------------------------------DEPARTAMENTO FUNCIONES ------------------------------------------------------------------

--PROCEDIMIENTO ALMACENADO PR_REGISTRAR_USUARIO_DEP
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_USUARIO_DEP
(p_departamento IN USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE,p_descripcion IN USUARIO_DEPARTAMENTOS.DESCRIPCION%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
INSERT INTO USUARIO_DEPARTAMENTOS(id_departamento,departamento,descripcion)
VALUES(SEQ_USUARIO_DEPARTAMENTOS.nextval,p_departamento,p_descripcion);
p_resultado := 'Departamento Registrado: ' || p_departamento;
END PR_REGISTRAR_USUARIO_DEP;


--PROCEDIMIENTO ALMACENADO PR_EDITAR_USUARIO_DEP
CREATE OR REPLACE PROCEDURE PR_EDITAR_USUARIO_DEP
(p_id_departamento IN USUARIO_DEPARTAMENTOS.ID_DEPARTAMENTO%TYPE,p_departamento IN USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE,
p_descripcion IN USUARIO_DEPARTAMENTOS.DESCRIPCION%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
UPDATE USUARIO_DEPARTAMENTOS
SET DEPARTAMENTO = p_departamento,
    DESCRIPCION = p_descripcion
WHERE ID_DEPARTAMENTO LIKE p_id_departamento;
p_resultado := 'Departamento ' || p_departamento || ' modificado';
END PR_EDITAR_USUARIO_DEP;  



--PROCEDIMIENTO ALMACENADO PR_BUSCAR_USUARIO_DEP
CREATE OR REPLACE PROCEDURE PR_BUSCAR_USUARIO_DEP
(p_id_departamento IN USUARIO_DEPARTAMENTOS.ID_DEPARTAMENTO%TYPE,p_departamento OUT USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE
, p_descripcion OUT USUARIO_DEPARTAMENTOS.DESCRIPCION%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
SELECT DEPARTAMENTO , DESCRIPCION 
INTO p_departamento, p_descripcion
FROM USUARIO_DEPARTAMENTOS
WHERE ID_DEPARTAMENTO LIKE p_id_departamento;
p_resultado := 'Datos encontrados';
END PR_BUSCAR_USUARIO_DEP;


--PROCEDIMIENTO PR_BUSCAR_UNIDAD_POR_DEP
CREATE OR REPLACE PROCEDURE PR_BUSCAR_UNIDAD_POR_DEP
(p_departamento IN USUARIO_DEPARTAMENTOS.DEPARTAMENTO%TYPE, p_id_departamento OUT USUARIO_DEPARTAMENTOS.ID_DEPARTAMENTO%TYPE,
p_descripcion OUT USUARIO_DEPARTAMENTOS.DESCRIPCION%TYPE,p_mensaje OUT VARCHAR2)
IS
BEGIN
SELECT  ID_DEPARTAMENTO , DESCRIPCION
INTO p_id_departamento ,p_descripcion
FROM USUARIO_DEPARTAMENTOS
WHERE DEPARTAMENTO LIKE p_departamento AND ROWNUM = 1;
p_mensaje := 'Departamento encontrado';
END PR_BUSCAR_UNIDAD_POR_DEP;


--PROCEDIMIENTO MOSTRAR UNIDADES
--CABEZA DEL PAQUETE Y PROCEDIMIENTO 
CREATE OR REPLACE PACKAGE MOSTRAR_USUARIO_DEP IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_USUARIO_DEP (v_cursor OUT vCursor);
END MOSTRAR_USUARIO_DEP;

/ --ESTO SEPARA LA CABEZA CON EL CUERPO, NO QUITARLA, DARA ERROR Y TODO SE DERRUMBARA

--CUERPO DEL PAQUETE Y EL PROCEDIMIENTO
CREATE OR REPLACE PACKAGE BODY MOSTRAR_USUARIO_DEP IS
PROCEDURE  PR_MOSTRAR_USUARIO_DEP(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT ID_DEPARTAMENTO, DEPARTAMENTO , DESCRIPCION 
    FROM USUARIO_DEPARTAMENTOS
    ORDER BY DEPARTAMENTO DESC;
END  PR_MOSTRAR_USUARIO_DEP;
END MOSTRAR_USUARIO_DEP;


--------------------------------------------------------TIPO PERMISOS FUNCIONES------------------------------------------------------------

--PROCEDIMIENTO ALMACENADO PR_REGISTRAR_TIPO_PERMISO
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_TIPO_PERMISO
(p_tipo IN PERMISO_TIPOS.TIPO%TYPE,p_dias IN PERMISO_TIPOS.DIAS%TYPE,p_descripcion IN PERMISO_TIPOS.DESCRIPCION%TYPE,
p_estado_tipo IN PERMISO_TIPOS.ESTADO_TIPO%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
INSERT INTO PERMISO_TIPOS(id_tipo,tipo,dias,descripcion,estado_tipo)
VALUES(SEQ_PERMISO_TIPOS.nextval,p_tipo,p_dias,p_descripcion,p_estado_tipo);
p_resultado := 'Tipo de Permiso Registrado: ' || p_tipo;
END PR_REGISTRAR_TIPO_PERMISO;


--PROCEDIMIENTO ALMACENADO PR_EDITAR_TIPO_PERMISO
CREATE OR REPLACE PROCEDURE PR_EDITAR_TIPO_PERMISO
(p_id_tipo IN PERMISO_TIPOS.ID_TIPO%TYPE,p_tipo IN PERMISO_TIPOS.TIPO%TYPE, p_dias IN PERMISO_TIPOS.DIAS%TYPE,
p_descripcion IN PERMISO_TIPOS.DESCRIPCION%TYPE, p_estado_tipo IN PERMISO_TIPOS.ESTADO_TIPO%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
UPDATE PERMISO_TIPOS
SET TIPO = p_tipo,
    DIAS = p_dias,
    DESCRIPCION = p_descripcion,
    ESTADO_TIPO = p_estado_tipo
WHERE ID_TIPO LIKE p_id_tipo;
p_resultado := 'Tipo de permiso ' || p_tipo || ' modificado';
END PR_EDITAR_TIPO_PERMISO;    


--PROCEDIMIENTO ALMACENADO PR_BUSCAR_TIPO_PERMISO
CREATE OR REPLACE PROCEDURE PR_BUSCAR_TIPO_PERMISO
(p_id_tipo IN PERMISO_TIPOS.ID_TIPO%TYPE,p_tipo OUT PERMISO_TIPOS.TIPO%TYPE, p_dias OUT PERMISO_TIPOS.DIAS%TYPE,
p_descripcion OUT PERMISO_TIPOS.DESCRIPCION%TYPE, p_estado_tipo OUT PERMISO_TIPOS.ESTADO_TIPO%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
SELECT TIPO , DIAS , DESCRIPCION, ESTADO_TIPO
INTO p_tipo, p_dias , p_descripcion , p_estado_tipo
FROM PERMISO_TIPOS
WHERE ID_TIPO LIKE p_id_tipo;
IF(p_dias>0) THEN 
p_resultado := 'Datos encontrados';
ELSE 
p_resultado := 'No se encontraron datos asociados';
END IF;
END PR_BUSCAR_TIPO_PERMISO;


--PROCEDIMIENTO BUSCAR TIPO, POR TIPO
CREATE OR REPLACE PROCEDURE PR_BUSCAR_TIPO_TIPO
(p_tipo IN PERMISO_TIPOS.TIPO%TYPE, p_id_tipo OUT PERMISO_TIPOS.ID_TIPO%TYPE,p_dias OUT PERMISO_TIPOS.DIAS%TYPE,
p_descripcion OUT PERMISO_TIPOS.DESCRIPCION%TYPE,p_estado_tipo OUT PERMISO_TIPOS.ESTADO_TIPO%TYPE,p_mensaje OUT VARCHAR2)
IS
BEGIN
SELECT  ID_TIPO ,DIAS , DESCRIPCION , ESTADO_TIPO
INTO p_id_tipo, p_dias, p_descripcion , p_estado_tipo
FROM PERMISO_TIPOS
WHERE TIPO LIKE p_tipo AND ROWNUM = 1;
p_mensaje := 'Tipo permiso no encontrado';
IF(p_id_tipo>0) THEN
p_mensaje := 'Tipo permiso detectado';
END IF;
END PR_BUSCAR_TIPO_TIPO;


--PROCEDIMIENTO MOSTRAR TIPO PERMISO
--CABEZA DEL PAQUETE Y PROCEDIMIENTO 
CREATE OR REPLACE PACKAGE MOSTRAR_TIPO_PERMISOS IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_TIPO_PERMISOS (v_cursor OUT vCursor);
END MOSTRAR_TIPO_PERMISOS;

/ --ESTO SEPARA LA CABEZA CON EL CUERPO, NO QUITARLA, DARA ERROR Y TODO SE DERRUMBARA

--CUERPO DEL PAQUETE Y EL PROCEDIMIENTO
CREATE OR REPLACE PACKAGE BODY MOSTRAR_TIPO_PERMISOS IS
PROCEDURE  PR_MOSTRAR_TIPO_PERMISOS(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT ID_TIPO, TIPO , DIAS , DESCRIPCION , ESTADO_TIPO
    FROM PERMISO_TIPOS
    ORDER BY TIPO DESC;
END  PR_MOSTRAR_TIPO_PERMISOS;
END MOSTRAR_TIPO_PERMISOS;


---------------------------------------------------------FERIADO-----------------------------------------------------------
--AGREGAR UN ID FERIADO PARA MODIFICAR LA FECHA
/*CREATE TABLE FERIADO(
ID_FERIADO NUMBER(9,0),
FERIADO  TIMESTAMP NOT NULL PRIMARY KEY,
DESCRIPCION VARCHAR2(255) NOT NULL
);

DROP TABLE FERIADO;
DROP SEQUENCE SEQ_FERIADO;
CREATE SEQUENCE SEQ_FERIADO INCREMENT BY 1 MAXVALUE 9999999999 MINVALUE 1 CACHE 20;
*/

--GUARDAR FERIADO
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_FERIADO
(p_feriado IN FERIADO.FERIADO%TYPE,p_descripcion IN FERIADO.DESCRIPCION%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
INSERT INTO FERIADO(ID_FERIADO,FERIADO,DESCRIPCION)
VALUES(SEQ_FERIADO.nextval,p_feriado,p_descripcion);
p_resultado := 'Feriado Registrado: ' || p_feriado;
END PR_REGISTRAR_FERIADO;

--EDITAR FERIADO
CREATE OR REPLACE PROCEDURE PR_EDITAR_FERIADO
(p_id IN FERIADO.ID_FERIADO%TYPE, p_feriado IN FERIADO.FERIADO%TYPE,p_descripcion IN FERIADO.DESCRIPCION%TYPE, p_resultado OUT VARCHAR2)
IS
BEGIN
UPDATE FERIADO
SET FERIADO = p_feriado,
    DESCRIPCION = p_descripcion
WHERE ID_FERIADO LIKE p_id;
p_resultado := 'Feriado ' || p_feriado || ' modificado';
END PR_EDITAR_FERIADO;

--BUSCAR FERIADO POR ID
CREATE OR REPLACE PROCEDURE PR_BUSCAR_FERIADO_ID
(p_id IN FERIADO.ID_FERIADO%TYPE,p_feriado OUT FERIADO.FERIADO%TYPE,
p_descripcion OUT FERIADO.DESCRIPCION%TYPE,p_resultado OUT VARCHAR2)
IS
BEGIN
SELECT FERIADO , DESCRIPCION 
INTO p_feriado, p_descripcion
FROM FERIADO
WHERE ID_FERIADO LIKE p_id;
p_resultado := 'Datos encontrados';
END PR_BUSCAR_FERIADO_ID;


--MOSTRAR FERIADO
CREATE OR REPLACE PACKAGE MOSTRAR_FERIADO IS
TYPE vCursor IS REF CURSOR; --EL CURSOR QUE VAMOS A USAR EN JAVA, LO DEFINIMOS
PROCEDURE  PR_MOSTRAR_FERIADO (v_cursor OUT vCursor);
END MOSTRAR_FERIADO;
/
CREATE OR REPLACE PACKAGE BODY MOSTRAR_FERIADO IS
PROCEDURE  PR_MOSTRAR_FERIADO(v_cursor OUT vCursor) --ES DE TIPO CURSOR
IS
BEGIN
OPEN v_cursor FOR
    SELECT ID_FERIADO , FERIADO , DESCRIPCION
    FROM FERIADO
    ORDER BY FERIADO DESC;
END  PR_MOSTRAR_FERIADO;
END MOSTRAR_FERIADO;