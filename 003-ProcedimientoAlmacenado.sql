go
use master
go

USE bd_policlinico
GO

--****************************************************************************************************


CREATE PROC SP_AgregarUsuario(			-- BASICO SOLO PARA PRIMERA PRESENTACION  1
@NUsuario varchar(50),
@Clave varchar(50),
@IdRol int,
@IdEmpleado int,
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM usuario WHERE NUsuario = @NUsuario)

	insert into usuario(NUsuario,Clave,IdRol,idEmpleado) values (@NUsuario,@Clave,@IdRol,@IdEmpleado)
	--insert into usuario(Usuario,Clave,IdSede,IdRol) values (@Usuario,ENCRYPTBYPASSPHRASE(@Patron,@Clave),@IdSede,@IdRol)
	ELSE
		SET @Resultado = 0
end

go

--SP_AgregarUsuario 'papa','papa','1','1','llucas'
--select * from usuario
create procedure SP_ValidarUsuario(  -- BASICO SOLO PARA PRIMERA PRESENTACION  2
@NUsuario varchar(60),
@Clave varchar(60)
)
as
begin
SELECT u.IdUsuario
		     , u.NUsuario
			 , u.Clave		
		FROM usuario u
		WHERE u.NUsuario= @NUsuario and  u.Clave= @Clave
end
go
--

/****** Object:  StoredProcedure [dbo].[spAccesoSistema]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spAccesoSistema]
( @prmUser varchar(50),
  @prmPass varchar(50)
)
AS
	BEGIN
		SELECT U.IdUsuario, U.NUsuario, U.Clave, E.nombres, E.apPaterno, E.apMaterno, E.nroDocumento,E.idEmpleado
		FROM usuario U
		INNER JOIN Empleado E ON E.idEmpleado = U.idEmpleado
		WHERE U.NUsuario = @prmUser AND U.Clave = @prmPass AND U.Activo = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spAccesoSistemaUsuario]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAccesoSistemaUsuario]
( @prmUser varchar(50),
  @prmPass varchar(50)
)
AS
	BEGIN
		SELECT U.IdUsuario, U.NUsuario, U.Clave, E.nombres, E.apPaterno, E.apMaterno, E.nroDocumento,E.idEmpleado
		FROM Usuario U
		INNER JOIN Empleado E ON (E.idEmpleado = U.idEmpleado)
		WHERE U.NUsuario = @prmUser AND U.Clave = @prmPass AND U.Activo = 1
	END
GO

-- *****************************************************************************************************
--PROCEDMIENTO PARA acceser como paciente

create procedure usp_ValidaraccesoPaciente(
@NUsuario varchar(60),
@Clave varchar(60),
@idPaciente int output
)
as
begin
	set @idPaciente = 0
	if exists(select * from Paciente where [nusuario] COLLATE Latin1_General_CS_AS = @NUsuario and clave COLLATE Latin1_General_CS_AS = @Clave and estado = 1)
		set @idPaciente = (select top 1 idPaciente from Paciente where [nusuario]  COLLATE Latin1_General_CS_AS = @NUsuario and clave COLLATE Latin1_General_CS_AS = @Clave and estado = 1)
end

go
--
--PROCEDMIENTO PARA acceser como paciente 2///////////////////////////////////////////////
create procedure SP_ValidaraccesoPaciente(  -- BASICO SOLO PARA PRIMERA PRESENTACION  2
@NUsuario varchar(60),
@Clave varchar(60)
)
as
begin
SELECT p.idPaciente
		     , p.nusuario
			 , p.clave		
		FROM Paciente p
		WHERE p.nusuario= @NUsuario and  p.clave= @Clave
end
go
--- *********************************************************************************************************

--
/****** Object:  StoredProcedure [dbo].[spBuscarUsuarioROL]    Script Date: 24/10/2021 12:11:41 p. m. ******/
create proc spBuscarUsuarioN(
@NUsuario varchar(12),
@IdRol varchar(60)
)
as
begin 
	Select*from usuario where NUsuario like CONCAT('%',@NUsuario,'%')  or IdRol like CONCAT('%',@IdRol,'%')
end
go
-- *****************************************************************************************************
--PROCEDMIENTO PARA OBTENER USUARIO LOGIN

create procedure usp_LoginUsuario(
@NUsuario varchar(60),
@Clave varchar(60),
@IdUsuario int output
)
as
begin
	set @IdUsuario = 0
	if exists(select * from usuario where [NUsuario] COLLATE Latin1_General_CS_AS = @NUsuario and Clave COLLATE Latin1_General_CS_AS = @Clave and Activo = 1)
		set @IdUsuario = (select top 1 IdUsuario from usuario where [NUsuario]  COLLATE Latin1_General_CS_AS = @NUsuario and Clave COLLATE Latin1_General_CS_AS = @Clave and Activo = 1)
end

go
--- *********************************************************************************************************
/****** Object:  StoredProcedure [dbo].[spListarUsuario]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarUsuario]
AS
	BEGIN
		SELECT U.IdUsuario, U.NUsuario,oRol.Descripcion,U.Activo
		FROM usuario U
		inner join rol oRol on oRol.IdRol = U.IdRol
		order by U.IdUsuario
	END
GO
-- drop Procedure spListarUsuario
--- *********************************************************************************************************
/****** Object:  StoredProcedure [dbo].[spListarRol]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarRol]
AS
	BEGIN
		SELECT R.IdRol , R.Descripcion
		FROM Rol R
		WHERE R.Activo = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarDatosUsuario]    Script Date: 25/11/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosUsuario_PRUEBA]
(@IdUsuario int,
@NUsuario varchar(300))
as
	begin
		update usuario
		set usuario.NUsuario = @NUsuario 
		where usuario.IdUsuario = @IdUsuario
	end
GO

/****** Object:  StoredProcedure [dbo].[spActualizarDatosUsuario]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosUsuario]
(@prmIdUsuario INT,
@prmUsuario VARCHAR(50),
@prmClave VARCHAR(50),
@prmTipUser VARCHAR(50)
)
as
	begin
	
		update usuario
		set NUsuario = @prmUsuario,Clave =@prmClave
		where IdUsuario = @prmIdUsuario
	end
GO
--PROCEDMIENTO PARA OBTENER DETALLE USUARIO  menu
/****** Object:  StoredProcedure [dbo].[spEliminarMenu]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarMenu]
(@prmIdMenu int)
AS
	BEGIN
		UPDATE Menu
		SET estado = 0
		WHERE idMenu = @prmIdMenu
	END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListaMenuPrincipal]
AS
	BEGIN
		SELECT 0 idMenu, '-- Sin Menú --' nombre
		UNION
		SELECT idMenu, nombre
		FROM menu
		WHERE url = ''
	END

GO
/****** Object:  StoredProcedure [dbo].[spListarMenu]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarMenu]
AS
	BEGIN
		SELECT idMenu, 
			   nombre, 
			   isSubmenu, 
			   ISNULL(url, '') url, 
			   ISNULL(idMenuParent, 0) idMenuParent, 
			   estado,
			   show
		FROM Menu
		--WHERE estado = 1 
	END



GO
/****** Object:  StoredProcedure [dbo].[spListarMenuPermisos]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarMenuPermisos]
(@prmIdUsuario INT,
 @prmOption INT)
AS
	SET NOCOUNT ON
	BEGIN
		CREATE TABLE #TMPPERMISOS( IDTMPPERMISOS INT IDENTITY(1,1) NOT NULL
								 , IDUSUARIO INT
								 , UNOMBRES VARCHAR(50)
								 , ROL VARCHAR(100)
								 , IdMenu INT
								 , nombre VARCHAR(200)
								 , isSubMenu BIT
								 , url VARCHAR(200)
								 , idMenuParent INT
								 , orden INT)

		INSERT INTO #TMPPERMISOS(IDUSUARIO, UNOMBRES, ROL, idMenu, nombre, isSubMenu, url, idMenuParent, orden)
		SELECT U.IdUsuario
			 , U.NUsuario
			 , R.Descripcion
			 , M.idMenu
			 , M.nombre
			 , M.isSubmenu
			 , M.url
			 , ISNULL(M.idMenuParent, 0)
			 , M.orden
		FROM usuario U 
		INNER JOIN rol R ON (U.IdRol = R.IdRol)
		INNER JOIN permisos P ON(U.IdUsuario = P.IdUsuario)
		INNER JOIN Menu M ON (P.idMenu = M.idMenu)
		WHERE U.IdUsuario = @prmIdUsuario AND U.Activo = 1 AND M.estado = 1
		ORDER BY M.orden, M.idMenu


		IF @prmOption = 0
			BEGIN
				SELECT idMenu
					 , nombre
					 , isSubMenu
					 , url
					 , idMenuParent
				FROM #TMPPERMISOS
			END
		ELSE
			BEGIN
				SELECT idMenu
					 , nombre
					 , isSubMenu
					 , url
					 , ISNULL(idMenuParent, 0)idMenuParent
				FROM Menu
				WHERE idMenu NOT IN(SELECT IDMENU FROM #TMPPERMISOS)
			END

		DROP TABLE #TMPPERMISOS

	END

GO
/****** Object:  StoredProcedure [dbo].[spActualizaMenu]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizaMenu]
(@prmIdMenu int ,
 @prmNombreMenu varchar(200),
 @prmUrlMenu varchar(200),
 @prmIdMenuParent int,
 @prmIsSubMenu bit,
 @prmEstado bit)
AS
	BEGIN
		UPDATE menu
		SET nombre = @prmNombreMenu, 
		    url = @prmUrlMenu,
			idMenuParent = @prmIdMenuParent,
			isSubmenu = @prmIsSubMenu,
			estado = @prmEstado
		WHERE idMenu = @prmIdMenu
	END

GO
-- /////////////////////////////////////////PERMISOS////////////////////////////////////////
/****** Object:  StoredProcedure [dbo].[spRegistrarMenu]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarMenu]
(@prmNombre varchar(100),
 @prmIsSubmenu bit,
 @prmUrl varchar(200),
 @prmMenuParent int)
 AS
	BEGIN
		DECLARE @prmIdMenuParent INT
		IF @prmIsSubmenu = 0
			BEGIN
				
				IF @prmMenuParent = 0
				BEGIN SET @prmIdMenuParent = NULL 
				END 
				ELSE 
				BEGIN SET @prmIdMenuParent = @prmMenuParent 
				END

				INSERT INTO Menu(nombre, isSubmenu, url, idMenuParent, estado, show, orden)
				VALUES(@prmNombre, @prmIsSubmenu, @prmUrl, @prmIdMenuParent, 1, 1, 7)
			END
		ELSE 
			BEGIN 
					INSERT INTO Menu(nombre, isSubmenu, url, idMenuParent, estado, show, orden)
					VALUES(@prmNombre, @prmIsSubmenu, @prmUrl, @prmMenuParent, 1, 1, 7)
			END
	END
GO

/****** Object:  StoredProcedure [dbo].[spMenuPorEmpleado]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMenuPorEmpleado] 
(@prmIdEmpleado int)
AS
	BEGIN
		SELECT M.idMenu, 
			   M.nombre, M.url, 
			   M.isSubmenu, 
			   ISNULL(M.idMenuParent, 0) idMenuParent, 
			   M.estado MEstado,
			   P.estado,
			   M.show
		FROM Menu M INNER JOIN 
			 Permisos P ON (M.idMenu = P.idMenu) INNER JOIN 
			 usuario U ON (U.IdUsuario = P.IdUsuario)
		WHERE U.IdUsuario = @prmIdEmpleado 
		  AND P.estado = 1	
		ORDER BY M.orden
	END
GO
/****** Object:  StoredProcedure [dbo].[spRegistrarEliminarPermiso]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarEliminarPermiso]
(@prmIdMenu int,
 @prmIdUsuario int,
 @prmOpcion int)
AS
	SET NOCOUNT ON
	BEGIN
		IF @prmOpcion = 1  -- CREAR
			BEGIN
				
				IF NOT EXISTS(SELECT TOP 1 1 FROM permisos WHERE IdUsuario = @prmIdUsuario AND idMenu = @prmIdMenu)
					BEGIN
						INSERT INTO permisos(idMenu, IdUsuario, estado)
						VALUES(@prmIdMenu, @prmIdUsuario, 1)
					END
			END
		ELSE IF @prmOpcion = 0
			BEGIN		   -- ELIMINAR 
				DELETE FROM permisos 
				WHERE IdUsuario = @prmIdUsuario AND
					  idMenu = @prmIdMenu
			END
	END


GO
/****** Object:  StoredProcedure [dbo].[spMenuPorUsuario]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMenuPorUsuario] 
(@prmIdUsuario int)
AS
	BEGIN
		SELECT M.idMenu, 
			   M.nombre, M.url, 
			   M.isSubmenu, 
			   ISNULL(M.idMenuParent, 0) idMenuParent, 
			   M.estado MEstado,
			   P.estado,
			   M.show
		FROM Menu M INNER JOIN 
			 permisos P ON (M.idMenu = P.idMenu) INNER JOIN 
			 usuario U ON (U.IdUsuario = P.IdUsuario)
		WHERE U.IdUsuario = @prmIdUsuario 
		  AND P.estado = 1	
		ORDER BY M.orden
	END



GO

-- /////////////////////////////////////////USUARIOS////////////////////////////////////////
--PROCEDMIENTO PARA OBTENER USUARIOS
CREATE PROC usp_ObtenerUsuario
as
begin
 select u.IdUsuario,u.NUsuario,u.Clave,u.IdRol,r.Descripcion[DescripcionRol],u.Activo from usuario u
 inner join rol r on r.IdRol = u.IdRol
end

go
--PROCEDIMIENTO PARA REGISTRAR USUARIO
CREATE PROC usp_RegistrarUsuario(
@NUsuario varchar(50),
@Clave varchar(50),
@IdRol int,
@IdEmpleado int,
@Patron varchar(50),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM usuario WHERE NUsuario = @NUsuario)
		insert into usuario(NUsuario,Clave,IdRol,idEmpleado) values (
		 @NUsuario,@Clave,@IdRol,@IdEmpleado)
	ELSE
		SET @Resultado = 0
	
end
go
select * from usuario
/****** Object:  StoredProcedure [dbo].[spRegistrarUsuario]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarUsuario]
(
@NUsuario VARCHAR(20),
@Clave VARCHAR(20),
@idRol INTEGER,
@IdEmpleado int,
@prmEstado bit
)
AS
	BEGIN
		INSERT INTO usuario(NUsuario,Clave,IdRol,idEmpleado,Activo)
		VALUES(@NUsuario,@Clave,@idRol,@IdEmpleado,@prmEstado);
	END
GO
--

/****** Object:  StoredProcedure [dbo].[spListarUsuarios]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarUsuarios]
AS
	BEGIN
		SELECT U.IdUsuario
		     , E.nombres
			 , E.apPaterno
			 , E.apMaterno
		     , U.NUsuario
			 , U.Clave
			 , E.nroDocumento
			 , R.Descripcion
		FROM Usuario U
		INNER JOIN Empleado E ON E.idEmpleado = U.idEmpleado
		INNER JOIN Rol R ON R.IdRol = U.IdRol
		WHERE U.Activo = 1
	END
GO
--
/****** Object:  StoredProcedure [dbo].[spListarEspecialidad]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarEspecialidad]
AS
	BEGIN
		SELECT e.idEspecialidad		     
		FROM Especialidad e
		WHERE e.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarUsuario]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarUsuario]
(@prmIdUsuario int)
AS
	BEGIN

		UPDATE usuario
		SET Activo = 0
		WHERE IdUsuario = @prmIdUsuario
	END
GO
--
--PROCEDIMIENTO PARA MODIFICAR USUARIO
create procedure usp_ModificarUsuario(
@IdUsuario int,
@NUsuario varchar(50),
@IdRol int,
@Activo bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	--IF NOT EXISTS (SELECT * FROM usuario WHERE NUsuario = @NUsuario and IdUsuario != @IdUsuario)
	IF NOT EXISTS (SELECT * FROM usuario WHERE rtrim(ltrim(NUsuario)) = rtrim(ltrim(@NUsuario)) and IdUsuario != @IdUsuario)
		update usuario set 
		NUsuario = @NUsuario,
		IdRol = @IdRol,
		Activo = @Activo
		where IdUsuario = @IdUsuario

	ELSE
		SET @Resultado = 0

end

go
--


-- ////////////////////////////SEDES////////////////////////////////////////////// 
go
--PROCEDMIENTO PARA OBTENER SEDES
--CREATE PROC usp_ObtenerSede
--as
--begin
-- select IdSede,nombre,ruc,direccion,telefono,activo from sede
--end
-- ********************************************************************************************************************************************************

-- ////////////////////////////ROLES//////////////////////////////////////////////


-- ////////////////////////////***TABLA PACIENTE**///////////////////////////////////////////
go

/****** Object:  StoredProcedure [dbo].[spListarPacientes]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarPacientes]
AS
	BEGIN
		SELECT P.idPaciente
			 , P.nroDocumento
		     , P.nombres
			 , P.apPaterno
			 , P.apMaterno
			 , P.edad
			 , P.sexo
			 , P.direccion
			 , P.telefono
			 , P.correo
		FROM Paciente P
		WHERE P.estado = 1
	END
GO

/****** Object:  StoredProcedure [dbo].[spBuscarPacienteDNI]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarPacienteDNI]
(@prmDni varchar(10)
)
AS
	BEGIN
		SELECT P.idPaciente
		     , P.nombres AS Nombres
			 , P.apPaterno AS ApPaterno
			 , P.apMaterno AS ApMaterno
			 , P.telefono AS Telefono
			 , P.correo AS Correo
			 , P.edad AS Edad
			 , P.sexo AS Sexo
		FROM Paciente P
		WHERE nroDocumento = @prmDni
		and P.estado = 'True'
	END
GO

---------------------------------------------------------------------------------------------------------------
--PROCEDIMIENTO PARA GUARDAR PACIENTE --> ADMIN
CREATE PROC usp_RegistrarPaciente(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEdad INT,
@prmSexo varchar(12),
@prmNroDoc VARCHAR(8), 
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(20),
@prmCorreo VARCHAR(50),
@prmEstado bit,
@prmnusuario VARCHAR(20),
@prmclave VARCHAR(20),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM paciente WHERE nroDocumento = @prmNroDoc or correo = @prmCorreo)

		insert into paciente(nombres, apPaterno, apMaterno, edad, sexo, nroDocumento, direccion, telefono,correo, estado, nusuario,clave)
		values(@prmNombres, @prmApPaterno, @prmApMaterno, @prmEdad, @prmSexo, @prmNroDoc, @prmDireccion, @prmTelefono,@prmCorreo, @prmEstado,@prmnusuario,@prmclave)

	ELSE
		SET @Resultado = 0
	
end

go
-- PARA LOGIN DE REGISTRO --> EL ACCESO DEL PACIENTE

/****** Object:  StoredProcedure [dbo].[spRegistrarPacientelOGIN]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarPacienteLOGIN]
(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmNroDoc VARCHAR(8), 
@prmTelefono VARCHAR(10),
@prmCorreo VARCHAR(50),
@prmEstado bit,
@prmnusuario VARCHAR(20),
@prmclave VARCHAR(20),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Paciente WHERE nroDocumento = @prmNroDoc OR correo = @prmCorreo)
		INSERT INTO Paciente(nombres, apPaterno, apMaterno, nroDocumento,telefono,correo, estado, nusuario,clave)
		VALUES(@prmNombres, @prmApPaterno, @prmApMaterno, @prmNroDoc,@prmTelefono,@prmCorreo, @prmEstado,@prmnusuario,@prmclave);
	ELSE
		SET @Resultado = 0
	
end
go
--

/****** Object:  StoredProcedure [dbo].[ContarUsuarioPaciente]    Script Date: 24/9/2021 15:59:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ContarUsuarioPaciente]
@prmnusuario varchar(50),
@prmNroDoc VARCHAR(8), 
@prmTelefono VARCHAR(10),
@prmCorreo VARCHAR(50)
as
begin

select count(*) from Paciente where nusuario=@prmnusuario or nroDocumento=@prmNroDoc or telefono=@prmTelefono or correo=@prmCorreo
end
GO
---
/****** Object:  StoredProcedure [dbo].[spRegistrarPaciente]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarPaciente]
(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEdad INT,
@prmSexo varchar(12),
@prmNroDoc VARCHAR(8), 
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(20),
@prmCorreo VARCHAR(50),
@prmEstado bit,
@prmnusuario VARCHAR(20),
@prmclave VARCHAR(20)
)
AS
	BEGIN
		INSERT INTO Paciente(nombres, apPaterno, apMaterno, edad, sexo, nroDocumento, direccion, telefono,correo, estado, nusuario,clave)
		VALUES(@prmNombres, @prmApPaterno, @prmApMaterno, @prmEdad, @prmSexo, @prmNroDoc, @prmDireccion, @prmTelefono,@prmCorreo, @prmEstado,@prmnusuario,@prmclave);
	END
GO
---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
---
/****** Object:  StoredProcedure [dbo].[spActualizarDatosPaciente]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosPaciente]
(@prmIdPaciente integer,
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(12),
@prmCorreo VARCHAR(50)
)
as
	begin
		update Paciente
		set direccion = @prmDireccion, telefono = @prmTelefono, correo = @prmCorreo
		where idPaciente = @prmIdPaciente
	end
GO
---
---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
---

/****** Object:  StoredProcedure [dbo].[spModificarDatosPaciente]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spModificarDatosPaciente]
(@prmIdPaciente integer,
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEdad INT,
@prmSexo varchar(12),
@prmNroDoc VARCHAR(8), 
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(20),
@prmCorreo VARCHAR(50),
@prmImagen VARCHAR(60),
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Paciente WHERE nroDocumento = @prmNroDoc and idPaciente != @prmIdPaciente )
		update Paciente
		set nombres = @prmNombres, apPaterno = @prmApPaterno, apMaterno = @prmApMaterno,edad=@prmEdad,sexo=@prmSexo,nroDocumento=@prmNroDoc,direccion=@prmDireccion,telefono=@prmTelefono,correo=@prmCorreo,imagen=@prmImagen
		where idPaciente = @prmIdPaciente
	ELSE
		SET @Resultado = 0
	end
GO
---
---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****** Object:  StoredProcedure [dbo].[spModificarDatosUsuPaciente]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spModificarDatosUsuPaciente]
(@prmIdPaciente integer,
@prmnusuario VARCHAR(20),
@prmclave VARCHAR(20),
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Paciente WHERE nusuario = @prmnusuario and idPaciente != @prmIdPaciente )
		update Paciente
		set nusuario = @prmnusuario, clave = @prmclave
		where idPaciente = @prmIdPaciente
	ELSE
		SET @Resultado = 0
	end
GO
---
---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****** Object:  StoredProcedure [dbo].[spBuscarPacienteIdCita]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarPacienteIdCita]
(@prmIdCita INT)
AS
	BEGIN
		DECLARE @prmIdPaciente INT
		SET @prmIdPaciente = (SELECT idPaciente FROM Cita WHERE idCita = @prmIdCita)
		
		SELECT idPaciente, nombres, apPaterno, apMaterno, edad, sexo
		FROM  Paciente
		WHERE idPaciente = @prmIdPaciente
	END
GO

go
/****** Object:  StoredProcedure [dbo].[spEliminarPaciente]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarPaciente]
(@prmIdPaciente int)
AS
	BEGIN
		UPDATE Paciente
		SET estado = 0
		WHERE idPaciente = @prmIdPaciente
	END
GO


--PROCEDIMIENTO PARA ELIMINAR PACIENTE
create procedure usp_EliminarPaciente(
@idPaciente int,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	--validamos que ningun Paciente se encuentre asignado a una Cita
	IF not EXISTS (select top 1 * from cita c
inner join paciente p on p.idPaciente = c.idPaciente
where p.idPaciente = @idPaciente)

		delete from paciente where idPaciente = @idPaciente
	ELSE
		SET @Resultado = 0

end

go



-- ////////////////////////////*** PROCEDMIENTO EMPLEADO**///////////////////////////////////////////
go
--PROCEDMIENTO PARA OBTENER EMPLEADO
CREATE PROC usp_ObtenerEmpleado
as
begin
 select e.idEmpleado,e.nombres,e.apPaterno,e.apMaterno,e.nroDocumento,e.correo,e.estado,e.imagen from Empleado e WHERE estado = 1
end

go

/****** Object:  StoredProcedure [dbo].[spListarEmpleados]    Script Date: 25/11/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarEmpleados]
AS
	BEGIN
		SELECT E.idEmpleado
			 , E.nroDocumento
		     , E.nombres
			 , E.apPaterno
			 , E.apMaterno
			 , E.telefono
			 , E.correo
		     , E.imagen
		FROM Empleado E		
		WHERE E.estado = 1
		order by E.idEmpleado
	END
GO

/****** Object:  StoredProcedure [dbo].[spActualizarDatosEmpleado]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosEmpleado]
(@prmidEmpleado int,
@prmapPaterno varchar(30),
@prmapMaterno varchar(30),
@prmimagen varchar(100)
)
as
	begin
		update Empleado
		set Empleado.apPaterno = @prmapPaterno,Empleado.apMaterno = @prmapMaterno, Empleado.imagen = @prmimagen
		where Empleado.idEmpleado = @prmidEmpleado
	end
GO
/****** Object:  StoredProcedure [dbo].[spBuscarEmpleado]    Script Date: 24/10/2021 12:11:41 p. m. ******/
-- **************************************************************************************************** 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarEmpleado]
(@prmNroDocumento varchar(8))
AS
	BEGIN
		SELECT U.idEmpleado
		     , E.nombres
			 , E.apPaterno
			 , E.apMaterno
			 , E.nroDocumento
			 , R.Descripcion
			 , U.NUsuario
		FROM Usuario U
		inner join Empleado E ON E.idEmpleado = U.idEmpleado
		INNER JOIN rol R ON (R.IdRol = U.IdRol)
		WHERE E.nroDocumento = @prmNroDocumento
	END
GO
--------------******************** OPCION 2  REGISTRAR EMPLEADO**************-----------------------
CREATE PROCEDURE [dbo].[spRegistrarEmpleado]
(
@nombres varchar(50),
@apPaterno varchar(20),
@apMaterno varchar(20),
@nroDocumento VARCHAR(8),
@telefono INTEGER,
@correo VARCHAR(50),
@estado bit,
@imagen VARCHAR(100),
@IdUsuario INTEGER
)
AS
	BEGIN
		insert into Empleado(nombres, apPaterno, apMaterno,nroDocumento, telefono, correo,estado, imagen)
		values(@nombres,@apPaterno,@apMaterno,@nroDocumento,@telefono,@correo,@estado,@imagen)
	END
GO

--------------******************** OPCION 2  REGISTRAR EMPLEADO**************-----------------------
CREATE procedure usp_RegistrarEmpleado(
@nombres varchar(50),
@apPaterno varchar(20),
@apMaterno varchar(20),
@nroDocumento VARCHAR(8),
@telefono INTEGER,
@correo VARCHAR(50),
@estado bit,
@imagen VARCHAR(100),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Empleado WHERE nroDocumento = @nroDocumento)
		insert into Empleado(nombres, apPaterno, apMaterno,nroDocumento,telefono , correo,estado, imagen)
		values(@nombres,@apPaterno,@apMaterno,@nroDocumento,@telefono,@correo,@estado,@imagen)

	ELSE
		SET @Resultado = 0
	
end

go
--

--PROCEDIMIENTO PARA MODIFICAR EMPLEADO---opcion 2 **************//////////////////*************** ////////////////////////////////--->
create procedure usp_ModificarEmpleado(
@idEmpleado int,
@nombres VARCHAR(30),
@apPaterno VARCHAR(40),
@apMaterno VARCHAR(40),
@nroDocumento INTEGER,
@telefono INTEGER,
@correo VARCHAR(50),
@estado bit,
@imagen VARCHAR(60),
@IdUsuario INTEGER,

@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Empleado WHERE nroDocumento = @nroDocumento and idEmpleado != @idEmpleado)
		
		update Empleado set 
		nombres=@nombres,
		apPaterno = @apPaterno,
		apMaterno = @apMaterno,
		nroDocumento = @nroDocumento,
		telefono = @telefono,
		correo = @correo,
		estado = @estado,
		imagen = @imagen
		where idEmpleado = @idEmpleado
	ELSE
		SET @Resultado = 0

end
go
/****** Object:  StoredProcedure [dbo].[[spEliminarEmpleado]]  *** 1 ***  Script Date: 25/11/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarEmpleado]
(@Id_empleado int)
AS
	BEGIN
		UPDATE Empleado
		SET estado = 0
		WHERE idEmpleado = @Id_empleado
	END
GO 
/****** Object:  StoredProcedure [dbo].[usp_EliminarEmpleado]  *** 2 ***  Script Date: 25/11/2021 12:11:41 p. m. ******/
create procedure usp_EliminarEmpleado(
@Id_empleado int,
@Resultado bit output
)
as
begin
		delete from Empleado where idEmpleado = @Id_empleado
end

go



/****** Object:  StoredProcedure [dbo].[spListarCitas]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitas]

AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 
		ORDER BY C.hora ASC
	END

GO

/****** Object:  StoredProcedure [dbo].[spListarCitasEstado]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasEstado]
(@prmDNI varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 --AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			 AND P.nroDocumento = @prmDNI
		ORDER BY C.idCita Desc
	END

GO

/****** Object:  StoredProcedure [dbo].[spListarCitasEstado]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasHistoria]
(@prmDNI varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion,C.estado
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado IN ('A','C') AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND --C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  P.nroDocumento = @prmDNI
		ORDER BY C.fechaReserva desc
	END

GO
SELECT * FROM Cita
/****** Object:  StoredProcedure [dbo].[spListarCitasDNI]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasDNI]
(@prmDNI varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND P.nroDocumento = @prmDNI
		ORDER BY C.idCita Desc
	END
GO

/****** Object:  StoredProcedure [dbo].[spListarCitasESPECIALIDAD]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasESPECIALIDAD]
(@prmEspecialidad varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'A' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND E.descripcion = @prmEspecialidad
		ORDER BY C.idCita Desc
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarCitasFECHA]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasFECHA]
(@prmfecha datetime)
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND C.fechaReserva = @prmfecha
		ORDER BY C.idCita Desc
	END
GO

	
/****** Object:  StoredProcedure [dbo].[spListarEspecialidades]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarEspecialidades]
AS
	BEGIN
		SELECT E.idEspecialidad, E.descripcion
		FROM Especialidad E
		WHERE E.estado = 1
	END
GO

/****** Object:  StoredProcedure [dbo].[spListarMedicoEsp]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarMedicoEsp]
( @prmIdEspecialidad INT
)
AS
	BEGIN
		SELECT M.idMedico,oEmpleado.nombres,oEmpleado.apPaterno,oEmpleado.apMaterno,M.Titulo,M.Cargo,M.CMP,oEspecialidad.descripcion
		FROM Medico M
		INNER JOIN Especialidad oEspecialidad on  (oEspecialidad.idEspecialidad = M.idEspecialidad)
		INNER JOIN Empleado oEmpleado ON (oEmpleado.idEmpleado = M.idEmpleado)		
		WHERE M.idEspecialidad = @prmIdEspecialidad		
	END
GO

/****** Object:  StoredProcedure [dbo].[spListarMedicoApe]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarMedicoApe]
( @prmIdApellidoP varchar(20)
)
AS
	BEGIN
		SELECT M.idMedico,oEmpleado.nombres,oEmpleado.apPaterno,oEmpleado.apMaterno,M.Titulo,M.Cargo,M.CMP,oEspecialidad.descripcion
		FROM Medico M
		INNER JOIN Especialidad oEspecialidad on  (oEspecialidad.idEspecialidad = M.idEspecialidad)
		INNER JOIN Empleado oEmpleado ON (oEmpleado.idEmpleado = M.idEmpleado)		
		WHERE oEmpleado.apPaterno = @prmIdApellidoP		
	END
GO


/****** Object:  StoredProcedure [dbo].[sp_ListarMedico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ListarMedico]
AS
	BEGIN
		SELECT M.idMedico,oEmpleado.nombres,oEmpleado.apPaterno,oEmpleado.apMaterno,M.Titulo,M.Cargo,M.CMP,oEspecialidad.descripcion
		FROM Medico M
		INNER JOIN Especialidad oEspecialidad on  (oEspecialidad.idEspecialidad = M.idEspecialidad)
		INNER JOIN Empleado oEmpleado ON (oEmpleado.idEmpleado = M.idEmpleado)
		where oEspecialidad.estado = 'true'
		AND M.estado = 'true'
		order by oEmpleado.apPaterno desc
	END
GO



/****** Object:  StoredProcedure [dbo].[spActualizarEstadoCita]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarEstadoCita]
(@prmIdCita INT, @prmEstado varchar(1))
AS
	BEGIN
		UPDATE Cita
		SET estado = @prmEstado -- Atendido
		WHERE idCita = @prmIdCita
	END
GO

--DROP PROC usp_RegistrarCita
--PROCEDIMIENTO PARA GUARDAR Recetas--------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>> REGISTRAR CITA <<<<<<<<<<<<<<<<<<<<<<<<<<<
CREATE PROC usp_RegistrarCita(
@idMedico int,
@idPaciente int,
@fechaReserva datetime,
@estado char(1),
@hora varchar(6),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Cita WHERE idMedico = @idMedico)

		INSERT INTO Cita(idMedico, idPaciente, fechaReserva,estado , hora)
		VALUES(@idMedico, @idPaciente, @fechaReserva, @estado, @hora);
	ELSE
		SET @Resultado = 0
end
go
--
/****** Object:  StoredProcedure [dbo].[sp_ListarxEstadoDeCita]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ConsultaxEstadoCitas]
(@prmidPaciente int)
AS
	BEGIN
		SELECT *
		FROM Cita		
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'		
			  idPaciente = @prmidPaciente
	END

-- ///////////////////////////////////////////////
  -- ////////////////////////////***MEDICO**///////////////////////////////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [dbo].[spBuscarMedico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarMedico] 
(@prmDni varchar(8))
AS
	BEGIN
		SELECT M.idMedico
			 , E.idEmpleado
			 , E.nombres as nombre
			 , E.apPaterno
			 , E.apMaterno
			 , ES.idEspecialidad
			 , ES.descripcion
			 , M.estado as estadoMedico
		FROM Medico M 
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN Especialidad ES ON (M.idEspecialidad = ES.idEspecialidad)
		WHERE M.estado = 1
		AND E.nroDocumento = @prmDni
	END
GO

/****** Object:  StoredProcedure [dbo].[spActualizarDatosMedico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosMedico]
(@prmIdMedico int,
@prmDocumento varchar(50)

)
as
	begin
	declare @idemple int;

	 set @idemple =  (select idEmpleado 
	from Medico where idMedico = @prmIdMedico)
		
		
		update Empleado
		set nroDocumento = @prmDocumento
		where Empleado.idEmpleado = @idemple
	end
GO

/****** Object:  StoredProcedure [dbo].[spRegistrarMedico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarMedico]
(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEspecialidad INT,
@prmNroDoc VARCHAR(8), 
@prmTelefono int, 
@prmCorreo VARCHAR(35), 
@prmTitulo VARCHAR(20), 
@prmCargo VARCHAR(30), 
@prmCMP VARCHAR(30), 
@prmImagen VARCHAR(150), 
@prmEstado bit
)
AS
	BEGIN

	    DECLARE @idEmpleado int;

		INSERT INTO Empleado(nombres,apPaterno, apMaterno, nroDocumento,telefono,correo,estado,imagen)
		VALUES(@prmNombres,@prmApPaterno, @prmApMaterno,@prmNroDoc,@prmTelefono,@prmCorreo, @prmEstado,@prmImagen);

		-- OBTENER EL ULTIMO REGISTRO INSERTADO EN LA TABLA 
			SET @idEmpleado= SCOPE_IDENTITY();

		INSERT INTO Medico(Titulo,Cargo,CMP,idEmpleado, idEspecialidad,estado)
		VALUES(@prmTitulo,@prmCargo,@prmCMP,@idEmpleado, @prmEspecialidad, @prmEstado);
		
	END
GO

/****** Object:  StoredProcedure [dbo].[spListarMedicos]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarMedicos]
AS
	BEGIN
		SELECT M.idMedico
		     , E.nombres
			 , E.apPaterno
			 , E.apMaterno
			 , E.nroDocumento
			 , M.Cargo
			 , ES.descripcion
		FROM Medico M
		INNER JOIN Empleado E ON M.idEmpleado = E.idEmpleado
		INNER JOIN Especialidad ES on M.idEspecialidad = ES.idEspecialidad
		WHERE M.estado = 1 and E.estado = 1 and Es.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarMedico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarMedico]
(@prmIdMedico int)
AS
	BEGIN
	    DECLARE @idem int;
	   set @idem =(Select idEmpleado from Medico
	   where idMedico = @prmIdMedico)

		UPDATE Medico
		SET estado = 0
		WHERE idMedico = @prmIdMedico

		UPDATE Empleado
		SET estado = 0
		WHERE idEmpleado = @idem
	END
GO


-- /////////////////////////////////////////ESPECIALIDAD////////////////////////////////////////

go
--PROCEDMIENTO PARA OBTENER ESPECIALIDAD
CREATE PROC usp_ObtenerEspecialidad
as
begin
 select idEspecialidad,descripcion from Especialidad
end
go



/****** Object:  StoredProcedure [dbo].[spRegistrarEspecialidad]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarEspecialidad]
(

@Nombres VARCHAR(20)

)
AS
	BEGIN
		insert into especialidad(descripcion)
		values(@Nombres)
	END
GO

--PROCEDIMIENTO PARA GUARDAR ESPECIALIDAD
CREATE PROC sp_RegistrarEspecialidad(
@Nombres VARCHAR(30),
@Resultado bit output
)as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM Especialidad WHERE descripcion = @Nombres)

		insert into especialidad(descripcion)
		values(@Nombres)

	ELSE
		SET @Resultado = 0
	end
	go

/****** Object:  StoredProcedure [dbo].[spActualizarDatosEspecialidad]    Script Date: 25/11/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosEspecialidad]
(@Id_Especialidad int,
@Nombres VARCHAR(30))
as
	begin
		update Especialidad set 
		descripcion=@Nombres		
		where idEspecialidad = @Id_Especialidad
	end
GO

--PROCEDIMIENTO PARA MODIFICAR ESPECIALIDAD--> Segunda Opcion
create procedure usp_ModificarEspecialidad(
@Id_Especialidad int,
@Nombres VARCHAR(30),
@Estado bit,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM especialidad WHERE descripcion = @Nombres and idEspecialidad != @Id_Especialidad)
		
		update Especialidad set 
		descripcion=@Nombres,
		estado = @Estado
		where idEspecialidad = @Id_Especialidad
	ELSE
		SET @Resultado = 0
end
go

/****** Object:  StoredProcedure [dbo].[[spEliminarEspecialidad]]  *** 1 ***  Script Date: 25/11/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarEspecialidad]
(@Id_Especialidad int)
AS
	BEGIN
		UPDATE Especialidad
		SET estado = 0
		WHERE idEspecialidad = @Id_Especialidad
	END
GO 

--PROCEDIMIENTO PARA ELIMINAR ESPECIALIDAD---> Segunda Opcion
create procedure usp_EliminarEspecialidad(
@Id_Especialidad int,
@Resultado bit output
)
as
begin
	SET @Resultado = 1
	--validamos que ningun Especialidad se encuentre asignado a una Medico Especialidad
	IF not EXISTS (select top 1 * from Medico me
inner join Especialidad e on e.idEspecialidad = me.idEspecialidad
where e.idEspecialidad = @Id_Especialidad)

		delete from Especialidad where idEspecialidad = @Id_Especialidad
	ELSE
		SET @Resultado = 0
end
go


/****** Object:  StoredProcedure [dbo].[spRegistrarHorarioAtencion]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarHorarioAtencion]
(@prmIdMedico int,
 @prmHora varchar(5),
 @prmFecha datetime
)
AS
	BEGIN
		-- TRY CATCH
		BEGIN TRY
			DECLARE @hora int;
			DECLARE @idHorarioAtencion int;
			
			-- OBTENER EL ID RESPECTIVO DEL PARAMETRO HORA
			SET @hora = (SELECT H.idHoraInicio FROM HoraInicio H WHERE H.idHoraInicio = @prmHora);
						
			-- INSERT
			INSERT INTO HorarioATencion(idMedico, fecha, idHoraInicio, estado)
			VALUES(@prmIdMedico, @prmFecha, @hora, 1); 
			
			-- OBTENER EL ULTIMO REGISTRO INSERTADO EN LA TABLA HORARIOATENCION
			SET @idHorarioAtencion = SCOPE_IDENTITY();

			-- SELECT
			SELECT HA.idHorarioAtencion, HA.fecha, H.idHoraInicio, H.hora, HA.estado
			FROM HorarioAtencion HA
			INNER JOIN HoraInicio H ON(HA.idHoraInicio = H.idHoraInicio)
			WHERE HA.idHorarioAtencion = @idHorarioAtencion
		END TRY
		BEGIN CATCH
			ROLLBACK;
			-- RAISERROR('',,,,'')
			-- PRINT 'mensaje'
		END CATCH
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarHorarioAtencion]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarHorarioAtencion]
(@prmIdMedico int,
 @prmIdHorario int,
 @prmFecha datetime,
 @prmHora varchar(5)
)
AS
	BEGIN
		DECLARE @idHora int;

		SET @idHora = (SELECT H.idHoraInicio FROM HoraInicio  H WHERE H.hora = RTRIM(@prmHora));

		UPDATE HA
		SET HA.fecha = @prmFecha,
		    HA.idHoraInicio = @idHora
		FROM HorarioAtencion HA
		WHERE HA.idHorarioAtencion = @prmIdHorario
		AND HA.idMedico = @prmIdMedico
		
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarHorarioAtencionEstado]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarHorarioAtencionEstado]
( @prmIdHorarioAtencion int
)
AS
	BEGIN
		UPDATE HorarioAtencion 
		set estado = 0
		WHERE idHorarioAtencion = @prmIdHorarioAtencion

	END

GO
/****** Object:  StoredProcedure [dbo].[spEliminarHorarioAtencion]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarHorarioAtencion]
( @prmIdHorarioAtencion int
)
AS
	BEGIN
		UPDATE HorarioAtencion
		SET estado = 0
		WHERE idHorarioAtencion = @prmIdHorarioAtencion
	END
GO
/****** Object:  StoredProcedure [dbo].[spListaHorariosAtencion]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListaHorariosAtencionm]
(@prmIdMedico int
)
AS
	BEGIN
		SELECT M.idMedico, HA.idHorarioAtencion, HA.fecha, H.hora
		FROM Medico M
		INNER JOIN HorarioAtencion HA ON (M.idMedico = HA.idMedico)
		INNER JOIN HoraInicio H ON (HA.idHoraInicio = H.idHoraInicio)
		WHERE M.idMedico = @prmIdMedico
		AND  HA.fecha >= CONVERT(DATE, GETDATE())
		AND HA.estado = 1
	END
GO
--- ****//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////RESERVA DE CITA
/****** Object:  StoredProcedure [dbo].[spListaHorariosAtencion]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListaHorariosAtencion]
(@prmIdMedico int
)
AS
	BEGIN
		SELECT M.idMedico, HA.idHorarioAtencion, HA.fecha, H.hora
		FROM Medico M
		INNER JOIN HorarioAtencion HA ON (M.idMedico = HA.idMedico)
		INNER JOIN HoraInicio H ON (HA.idHoraInicio = H.idHoraInicio)
		WHERE M.idMedico = @prmIdMedico 
		AND CONVERT(VARCHAR(10), HA.fecha, 103) >= CONVERT(VARCHAR(10), GETDATE(), 103)
		AND HA.estado = 1
	END
GO

/****** Object:  StoredProcedure [dbo].[spListarHorariosAtencionPorFecha]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarHorariosAtencionPorFecha]
( @prmFecha DATE
)
AS
	BEGIN
		SELECT HA.idHorarioAtencion, HA.fecha, M.idMedico, E.nombres,E.apPaterno,E.apMaterno,E.nroDocumento, H.idHoraInicio, H.hora
		FROM HorarioAtencion HA 
		INNER JOIN Medico M ON (HA.idMedico = M.idMedico)
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN HoraInicio H ON (HA.idHoraInicio = H.idHoraInicio)
		WHERE CAST(HA.fecha AS DATE) = @prmFecha 
		AND HA.estado = 'true'
		AND HA.fecha >= CONVERT(DATE, GETDATE()) 
		AND M.estado = 'true'
		order by HA.fecha desc
	END
GO
--

/****** Object:  StoredProcedure [dbo].[spListarHorariosAtencion]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarHorariosAtencion]
( @prmIdEspecialidad INT
)
AS
	BEGIN
		SELECT HA.idHorarioAtencion, HA.fecha, M.idMedico, E.nombres,E.apPaterno,E.apMaterno,E.nroDocumento, H.idHoraInicio, H.hora
		FROM HorarioAtencion HA 
		INNER JOIN Medico M ON (HA.idMedico = M.idMedico)
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN HoraInicio H ON (HA.idHoraInicio = H.idHoraInicio)
		WHERE M.idEspecialidad = @prmIdEspecialidad
		AND HA.estado = 'true'
		AND HA.fecha >= CONVERT(DATE, GETDATE()) 
		AND M.estado = 'true'
		order by HA.fecha desc
	END
GO

/****** Object:  StoredProcedure [dbo].[spRegistrarCita]    Script Date: 24/10/2021 12:11:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarCita]
(
@idMedico int,
@idPaciente int,
@fechaReserva datetime,
@estado char(1),
@hora varchar(6)
)
AS
	BEGIN
		INSERT INTO Cita(idMedico, idPaciente, fechaReserva,estado , hora)
		VALUES(@idMedico, @idPaciente, @fechaReserva, @estado, @hora);
	END
GO
---
/****** Object:  StoredProcedure [dbo].[spRegistrarCita]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarCitap]
( @idMedico int,
  @idPaciente int,
  @fechaReserva datetime,
  @hora varchar(5)
)
AS
	BEGIN
		INSERT INTO Cita(idMedico, idPaciente, fechaReserva, estado, hora)
		VALUES(@idMedico, @idPaciente, @fechaReserva, 'P', @hora)
	END
GO
---
/****** Object:  StoredProcedure [dbo].[spListarCitas]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasp]
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 

		ORDER BY C.idCita Desc
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarCitasDNI]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasDNIp]
(@prmDNI varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND P.nroDocumento = @prmDNI
		ORDER BY C.idCita Desc
	END
GO
--
/****** Object:  StoredProcedure [dbo].[spListarCitasFECHA]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasFECHAp]
(@prmfecha datetime)
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND C.fechaReserva = @prmfecha
		ORDER BY C.idCita Desc
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarCitasESPECIALIDAD]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitasESPECIALIDADp]
(@prmEspecialidad varchar(10))
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion,E.descripcion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		INNER JOIN Medico as M on M.idMedico = C.idMedico
		INNER JOIN Especialidad as E on E.idEspecialidad = M.idEspecialidad
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1 AND C.fechaReserva >= CONVERT(DATE, GETDATE()) 
			  AND E.descripcion = @prmEspecialidad
		ORDER BY C.idCita Desc
	END
GO
--
/****** Object:  StoredProcedure [dbo].[spActualizarEstadoCita]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarEstadoCitap]
(@prmIdCita INT, @prmEstado varchar(1))
AS
	BEGIN
		UPDATE Cita
		SET estado = @prmEstado -- Atendido
		WHERE idCita = @prmIdCita
	END
GO
--
/****** Object:  StoredProcedure [dbo].[spRegistrarDiagnostico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarDiagnostico]
(@prmIdPaciente INT,
 @prmObservacion VARCHAR(500),
 @prmDiagnostico VARCHAR(500)
 )
AS
	SET NOCOUNT ON
	BEGIN
		DECLARE @prmFecha DATETIME = GETDATE()
		DECLARE @prmEstado BIT = 1
		DECLARE @prmIdHistoriaClinica INT
		-- guardar la historia clinica
		IF NOT EXISTS(SELECT TOP 1 idHistoriaClinica FROM HistoriaClinica WHERE idPaciente = @prmIdPaciente)
			BEGIN
				INSERT INTO HistoriaClinica(idPaciente, fechaApertura, estado)
				VALUES(@prmIdPaciente, @prmFecha, @prmEstado)

				SET @prmIdHistoriaClinica = SCOPE_IDENTITY()
			END
		ELSE
			BEGIN
				SET @prmIdHistoriaClinica = (SELECT TOP 1 idHistoriaClinica FROM HistoriaClinica WHERE idPaciente = @prmIdPaciente)
			END

		-- guardar el diagnostico	
		INSERT INTO Diagnostico(idHistoriaClinica, fechaEmision, observacion, estado,recetaMedica)
		VALUES(@prmIdHistoriaClinica, @prmFecha, @prmDiagnostico, @prmEstado,@prmObservacion)	
	END
GO
--*******************************************************************horarioatencion*******************************
-----------------------------
-- /////////////////////////////////////////////// UBIGEO ----> FALTA
go
--PROCEDMIENTO PARA OBTENER DEPARTAMENTO
CREATE PROC usp_ubigeo_departamento
as
begin
 select * from ubigeo_departamento
end

go


--PROCEDMIENTO PARA OBTENER PROVINCIA
CREATE PROC usp_ubigeo_provincia
as
begin
 select * from ubigeo_departamento
end

go

--PROCEDMIENTO PARA OBTENER DISTRITO
