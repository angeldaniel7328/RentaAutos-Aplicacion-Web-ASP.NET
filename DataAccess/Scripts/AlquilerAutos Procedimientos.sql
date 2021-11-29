USE [DBAlquierAutos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ActualizarAutomovil]
@IdAutomovil INT,
@Matricula VARCHAR(10)=NULL,
@Modelo VARCHAR(25)=NULL,
@Marca VARCHAR(25)=NULL,
@Año CHAR(4)=NULL,
@CuotaDia DECIMAL(10,2)=NULL,
@Disponibilidad INT=NULL,
@UrlFoto VARCHAR(MAX)=NULL

AS

BEGIN
	UPDATE Automoviles
	SET
	Matricula=ISNULL(@Matricula,Matricula),
	Modelo=ISNULL(@Modelo,Modelo),
	Marca=ISNULL(@Marca,Marca),
	Año=ISNULL(@Año,Año),
	CuotaDia=ISNULL(@CuotaDia,CuotaDia),
	Disponibilidad=ISNULL(@Disponibilidad,Disponibilidad),
	UrlFoto=ISNULL(@UrlFoto,UrlFoto)
	WHERE IdAutomovil=@IdAutomovil
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ActualizarCliente]
@IdCliente INT,
@Nombre VARCHAR(50)=NULL,
@Telefono VARCHAR(20)=NULL,
@Direccion VARCHAR(100)=NULL,
@Correo VARCHAR(100)=NULL,
@UrlFoto VARCHAR(MAX)=NULL

AS
BEGIN
	UPDATE Clientes
	SET
	Nombre=ISNULL(@Nombre,Nombre),
	Telefono=ISNULL(@Telefono,Telefono),
	Direccion=ISNULL(@Direccion,Direccion),
	Correo=ISNULL(@Correo,Correo),
	UrlFoto=ISNULL(@UrlFoto,UrlFoto)
	WHERE IdCliente=@IdCliente
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ConsultarAutomovilPorId]
@IdAutomovil INT

AS

BEGIN
	SELECT * FROM Automoviles
	WHERE IdAutomovil=@IdAutomovil
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ConsultarAutomoviles]
@Disponibilidad BIT=NULL
AS

BEGIN
	IF(@Disponibilidad IS NULL)
		BEGIN
			SELECT * FROM Automoviles
		END
	ELSE
		BEGIN
			SELECT * FROM Automoviles
			WHERE Disponibilidad=@Disponibilidad
		END
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ConsultarClientePorId]
@IdCliente INT

AS

BEGIN
	SELECT * FROM Clientes
	WHERE IdCliente=@IdCliente
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ConsultarClientes]
AS

BEGIN
SELECT * FROM Clientes
END
	
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ConsultarRentasPorEstado]
@Estado VARCHAR(10)

AS

BEGIN
	SELECT * FROM Rentas
	WHERE Estado=@Estado
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ConsultarRentasPorEstadoExtendida]
@Estado INT

AS

BEGIN
	SELECT R.IdRenta, R.FechaHora, R.Estado, R.IdAutomovil, R.IdCliente,
	A.Marca as MarcaAutomovil, A.UrlFoto as UrlFotoAutomovil,
	C.Nombre as NombreCliente, C.UrlFoto as UrlFotoCliente
	 FROM Rentas R

	INNER JOIN Automoviles A ON R.IdAutomovil=A.IdAutomovil
	INNER JOIN Clientes C ON R.IdCliente=C.IdCliente
	WHERE Estado=@Estado
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ConsultarRentasPorId]
@IdSalida INT

AS

BEGIN
	SELECT * FROM Salidas
	WHERE IdSalida=@IdSalida
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ConsultarRentasPorIdExtendida]
@IdRenta INT

AS

BEGIN
	SELECT R.IdRenta, R.FechaHora, R.Estado, R.IdAutomovil, R.IdCliente,
	A.Marca as MarcaAutomovil, A.UrlFoto as UrlFotoAutomovil,
	C.Nombre as NombreCliente, C.UrlFoto as UrlFotoCliente
	FROM Rentas R

	INNER JOIN Automoviles A ON R.IdAutomovil=A.IdAutomovil
	INNER JOIN Clientes C ON R.IdCliente=C.IdCliente
	WHERE IdRenta=@IdRenta
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EliminarAutomovil]
@IdAutomovil INT

AS

BEGIN
	DELETE Automoviles
	WHERE IdAutomovil=@IdAutomovil
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EliminarCliente]
@IdCliente INT

AS

BEGIN
	DELETE Clientes
	WHERE IdCliente=@IdCliente
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DevolverAutomovil]
@IdRenta INT,
@Estado INT

AS

BEGIN
DECLARE @IdAutomovil INT
DECLARE @IdCliente INT
	SELECT @IdAutomovil=IdAutomovil, @IdCliente=IdCliente FROM Rentas
	WHERE IdRenta=@IdRenta

	UPDATE Rentas
	SET
	Estado=@Estado
	WHERE IdRenta=@IdRenta

	UPDATE Automoviles
	SET
	Disponibilidad=1
	WHERE IdAutomovil=@IdAutomovil

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_InsertarAutomovil]
@Matricula VARCHAR(10),
@Modelo VARCHAR(5),
@Marca VARCHAR(25),
@Año CHAR(4),
@CuotaDia DECIMAL(10,2),
@UrlFoto VARCHAR(MAX)

AS

BEGIN
	INSERT INTO Automoviles(Matricula,Modelo,Marca,Año,CuotaDia,Disponibilidad,UrlFoto)
	VALUES (@Matricula,@Modelo,@Marca,@Año,@CuotaDia,1,@UrlFoto)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertarCliente]
@Nombre VARCHAR(50),
@Telefono VARCHAR(20),
@Direccion VARCHAR(100),
@Correo VARCHAR(100),
@UrlFoto VARCHAR(MAX)

AS
BEGIN
INSERT INTO Clientes(Nombre,Telefono,Direccion,Correo,UrlFoto)
VALUES (@Nombre,@Telefono,@Direccion,@Correo,@UrlFoto)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertarRenta]
@FechaHora DateTime,
@Estado INT,
@IdAutomovil INT,
@IdCliente INT

AS

BEGIN
	INSERT INTO Salidas(FechaHora,Estado,IdAutomovil,IdCliente)
	VALUES(@FechaHora,@Estado,@IdAutomovil,@IdCliente)
END
GO
