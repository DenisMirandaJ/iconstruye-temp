USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[Msg_ActivaServicioPMLinea]    Script Date: 3/11/2024 12:14:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Msg_ActivaServicioPMLinea] 
@idempresa int,
@idorgc int,
@iddoc int,
@idLinea int,
@idtipomail int,
@codigo varchar(250),
@cantidad real,
@glosa varchar(250),
@descripcion varchar(250),
@actor varchar(250)


AS 
BEGIN 

DECLARE @IdTipoMailDiferenciado INT;
EXEC dbo.Get_Mail_Diferenciado @IdEmpresa, @IdTipoMail, @IdTipoMailDiferenciado OUTPUT;
IF @IdTipoMailDiferenciado IS NULL
BEGIN
	SET @IdTipoMailDiferenciado = @IdTipoMail; 
END

DECLARE @Mensaje XML 

declare @XMLMensaje table
(
[idempresa] int, 
[idorgc] INT, 
[iddoc] int, 
[idLinea] int,
[idtipomail] int,
[codigo] varchar(250),
[cantidad] real,
[glosa] varchar(250),
[descripcion] varchar(250),
[actor] varchar(250)
)

INSERT INTO @XMLMensaje 
( 
[idempresa], 
[idorgc], 
[iddoc], 
[idLinea],
[idtipomail],
[codigo],
[cantidad],
[glosa],
[descripcion],
[actor]
) 
VALUES ( 
@idempresa ,
@idorgc ,
@iddoc ,
@idLinea,
@IdTipoMailDiferenciado,
@codigo,
@cantidad,
@glosa,
@descripcion,
@actor
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

DECLARE @Handle UNIQUEIDENTIFIER ; 

-- Dialog Conversation starts here 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CotizacionCierreServ TO 
	SERVICE 'PMEliminacionLineaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
	SELECT * FROM @XMLMensaje 
	return 
END


end

