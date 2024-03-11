USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicio_CreacionMaterialDesdePendiente]    Script Date: 3/11/2024 12:04:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicio_CreacionMaterialDesdePendiente]
 @IdEmpresa int,        
 @IdPendiente int,        
 @idMstrItem int,
 @IdTipoMail int
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
[IdEmpresa] int, 
[IdPendiente] int, 
[idMstrItem] int,
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
IdEmpresa, 
IdPendiente, 
idMstrItem,
IdTipoMail
) 
VALUES ( 
@IdEmpresa, 
@IdPendiente, 
@idMstrItem,
@IdTipoMailDiferenciado
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CreacionMaterialDesdePendienteServ TO 
	SERVICE 'CreacionMaterialDesdePendienteServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end