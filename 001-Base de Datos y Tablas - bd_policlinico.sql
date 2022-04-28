------------------------- SISTEMA DE RESERVA DE CITAS ---------------------------------
--Orden para ejecutar --
-- 1. tablas
-- 2. insert
-- 3. relaciones
--
go
use master
go
 drop DATABASE bd_policlinico
go
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE NAME = 'bd_policlinico')
CREATE DATABASE bd_policlinico
GO 

USE bd_policlinico
GO

-----------------------------------------------------------------------------------
--							CREACIÓN DE TABLAS
-----------------------------------------------------------------------------------
--(1) TABLA ROL
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ROL')
create table rol(
IdRol int primary key identity(1,1),
Descripcion varchar(60),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO
--(2) TABLA SEDE
--if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'sede')
--create table sede(
--IdSede int primary key identity(1,1),
--RUC varchar(60),
--Nombre varchar(60),
--Direccion varchar(100),
--Telefono varchar(50),
--Activo bit default 1,
--FechaRegistro datetime default getdate()
--)
GO

--(3) TABLA MENU
/****** Object:  Table [dbo].[Menu]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[idMenu] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](200) NOT NULL,
	[isSubmenu] [bit] NOT NULL,
	[url] [varchar](200) NULL,
	[idMenuParent] [int] NULL,
	[estado] [bit] NULL,
	[show] [bit] NULL,
	[orden] [int] NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[idMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--(6) TABLA PERMISOS
/****** Object:  Table [dbo].[Permisos]    Script Date: 24/08/2021 12:11:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permisos](
	[IdUsuario] [int] NOT NULL,
	[idMenu] [int] NOT NULL,
	[estado] [bit] NOT NULL,
	[FechaRegistro] [datetime] default getdate(),
 CONSTRAINT [PK_Permisos] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[idMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--(7) TABLA NOTIFICA
create table notificacion
(
id_notificacion int IDENTITY(1,1) NOT NULL,
descripcion varchar(100) NULL,
fecha_registro datetime default getdate(),
CONSTRAINT PK_id_notificacion PRIMARY KEY (id_notificacion)
)
GO

--(7) TABLA CITA
create table Cita
(
idCita int IDENTITY(1,1) NOT NULL,
idMedico int NOT NULL,
idPaciente int NOT NULL,
fechaReserva datetime NULL,
observacion varchar(350) NULL,
estado char(1) NULL,
hora varchar(6) NULL,
fecha_registro datetime default getdate(),
CONSTRAINT PK_cita PRIMARY KEY (idCita)
)
GO


CREATE TABLE Empleado   ---  //mellisa
(
idEmpleado int IDENTITY(1,1) NOT NULL,
	nombres varchar(50) NULL,
	apPaterno varchar(20) NULL,
	apMaterno varchar(20) NULL,
	nroDocumento varchar(8) NULL,
	telefono integer null,
	correo varchar(50) NULL,
	estado bit NULL,
	imagen varchar(500) NULL,
   fecha_Registro datetime default getdate(),
   CONSTRAINT PK_empleado PRIMARY KEY(idEmpleado)
)
GO
---
--(5) TABLA USUARIO
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'usuario')
create table usuario(
IdUsuario int primary key identity(1,1),
NUsuario varchar(60),
Clave varchar(60),
IdRol int references rol(IdRol),  --TIPO DE USUARIO
idEmpleado int references Empleado(idEmpleado),  --TIPO DE USUARIO
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO
------
CREATE TABLE Especialidad   -- Jean  MANTENIMIENTO
(
idEspecialidad int IDENTITY(1,1) NOT NULL,
descripcion varchar(25) NULL,
estado  bit default 1,
fecharegistro datetime default getdate(),
  CONSTRAINT PK_especialidad PRIMARY KEY (idEspecialidad)
)
GO

CREATE TABLE  Medico -- ARMANDO
(
 	idMedico int IDENTITY(1,1) NOT NULL,
	Titulo varchar(45) not null,
	Cargo varchar(45) not null,
	CMP int not null,
	idEmpleado int NOT NULL,
	idEspecialidad int  NULL,
	estado bit NULL,
  fecharegistro datetime default getdate(),
  CONSTRAINT PK_medico PRIMARY KEY (idMedico)
)
GO


CREATE TABLE  medico_sede
(
  id_ms INTEGER IDENTITY(1,1) NOT NULL,
  idMedico INTEGER NULL,
  IdSede INTEGER  NULL,
  CONSTRAINT PK_medico_sede PRIMARY KEY (id_ms),
)
GO

CREATE TABLE Paciente  --- RICARDO
(
idPaciente int IDENTITY(1,1) NOT NULL,
nombres varchar(50) NOT NULL,
apPaterno varchar(20) NOT NULL,
apMaterno varchar(20) NOT NULL,
edad int NULL,
sexo varchar(12) NULL,
nroDocumento varchar(8) NOT NULL,
direccion varchar(150) NULL,
telefono varchar(20) NULL,
correo varchar(50) NULL,
estado bit NULL,
imagen varchar(500) NULL,
nusuario varchar(35)  NULL,
clave varchar(35) NULL,
---IdUsuario INTEGER NULL,
--id_distrito VARCHAR(10) NULL,
fecharegistro datetime default getdate(),
CONSTRAINT PK_paciente PRIMARY KEY (idPaciente)
)
GO
--- **************************Tablas para el Proceso de de horario Medico
CREATE TABLE HoraInicio
(
	idHoraInicio int IDENTITY(1,1) NOT NULL,
	hora varchar(6) NULL,
  CONSTRAINT PK_idHoraInicio PRIMARY KEY (idHoraInicio)
)
go
CREATE TABLE DiaSemana
(
	idDiaSemana int IDENTITY(1,1) NOT NULL,
	nombreDiaSemana varchar(50) NULL,
  CONSTRAINT PK_idDiaSemana PRIMARY KEY (idDiaSemana)
)
go
create TABLE HorarioAtencion   -- TURNO LUIS LUCAS
(
  idHorarioAtencion INTEGER IDENTITY(1,1) NOT NULL,
  idMedico INTEGER NOT NULL,
  idHoraInicio int NOT NULL,
  fecha datetime null,
  fechaFin date NULL,
  estado bit  null,
  idDiaSemana int NULL,
  fecharegistro datetime default getdate(),
  CONSTRAINT PK_idHorarioAtencion PRIMARY KEY (idHorarioAtencion)

  
)
GO
/****** Object:  Table [dbo].[HistoriaClinica]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoriaClinica](
	[idHistoriaClinica] [int] IDENTITY(1,1) NOT NULL,
	[idPaciente] [int] NULL,
	[fechaApertura] [datetime] NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_HistoriaClinica] PRIMARY KEY CLUSTERED 
(
	[idHistoriaClinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Diagnostico]    Script Date: 28/09/2021 12:53:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Diagnostico](
	[idDiagnostico] [int] IDENTITY(1,1) NOT NULL,
	[idHistoriaClinica] [int] NOT NULL,
	[fechaEmision] [datetime] NULL,
	[observacion] [varchar](500) NULL,
	[estado] [bit] NULL,
	[recetaMedica] [varchar](500) NULL,
 CONSTRAINT [PK_Diagnostico] PRIMARY KEY CLUSTERED 
(
	[idDiagnostico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------------------------------------------------

CREATE TABLE ubigeo_departamento 
(
  id_departamento VARCHAR(10) NOT NULL,
  name VARCHAR(45) NOT NULL,
  CONSTRAINT PK_ubigeo_departamento PRIMARY KEY (id_departamento)
)
GO

CREATE TABLE ubigeo_distrito
(
  id_distrito VARCHAR(10) NOT NULL,
  name VARCHAR(45) NULL,
  id_provincia VARCHAR(10) NULL,
  id_departamento VARCHAR(10) NULL,
  CONSTRAINT PK_ubigeo_distrito PRIMARY KEY (id_distrito)
)
GO

CREATE TABLE ubigeo_provincia (
  id_provincia VARCHAR(10) NOT NULL,
  name VARCHAR(45) NOT NULL,
  id_departamento VARCHAR(10)  NULL,
  CONSTRAINT PK_ubigeo_provincia PRIMARY KEY (id_provincia)
)
GO





---- RELACIONES CLAVES FORANEAS ---------
-- TABLA CITA-------
ALTER TABLE Cita
ADD CONSTRAINT FK_medico FOREIGN KEY(idMedico) REFERENCES Medico(idMedico)
GO




ALTER TABLE Cita
ADD CONSTRAINT FK_paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(idPaciente)
GO


-- TABLA MEDICO --
ALTER TABLE Medico
ADD CONSTRAINT FK_idEmpleado5 FOREIGN KEY(idEmpleado) REFERENCES Empleado(idEmpleado)
GO



-- TABLA MEDICO_ESPECIALIDAD --
ALTER TABLE Medico
ADD CONSTRAINT FK_especialidad2 FOREIGN KEY(idEspecialidad) REFERENCES Especialidad(idEspecialidad)
GO



-- TABLA PACIENTE --
--ALTER TABLE paciente
--ADD CONSTRAINT FK_usuario4 FOREIGN KEY(IdUsuario) REFERENCES usuario(IdUsuario)
--GO


ALTER TABLE HorarioAtencion
ADD CONSTRAINT FK_medico3 FOREIGN KEY(idMedico) REFERENCES Medico(idMedico)
GO

ALTER TABLE HorarioAtencion
ADD CONSTRAINT FK_idhorario1 FOREIGN KEY(idHoraInicio) REFERENCES HoraInicio(idHoraInicio)
GO

ALTER TABLE HorarioAtencion
ADD CONSTRAINT FK_idDiaSemana1 FOREIGN KEY(idDiaSemana) REFERENCES DiaSemana(idDiaSemana)
GO

-- TABLA UBIGEO --

--ALTER TABLE ubigeo_distrito
--ADD CONSTRAINT FK_ubigeo_provincia FOREIGN KEY(id_provincia) REFERENCES ubigeo_provincia(id_provincia)
--GO

--ALTER TABLE ubigeo_distrito
--ADD CONSTRAINT FK_departamento1 FOREIGN KEY(id_departamento) REFERENCES ubigeo_departamento(id_departamento)
--GO

--ALTER TABLE ubigeo_provincia
--ADD CONSTRAINT FK_departamento2 FOREIGN KEY(id_departamento) REFERENCES ubigeo_departamento(id_departamento)
--GO

ALTER TABLE [dbo].[Diagnostico]  WITH CHECK ADD  CONSTRAINT [FK_Diagnostico_HistoriaClinica] FOREIGN KEY([idHistoriaClinica])
REFERENCES [dbo].[HistoriaClinica] ([idHistoriaClinica])
GO
ALTER TABLE [dbo].[Diagnostico] CHECK CONSTRAINT [FK_Diagnostico_HistoriaClinica]
GO