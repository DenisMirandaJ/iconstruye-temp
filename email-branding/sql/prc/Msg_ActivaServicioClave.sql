USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[Msg_ActivaServicioClave]    Script Date: 3/11/2024 9:42:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Msg_ActivaServicioClave 19,'Admin',9,'123456789'
ALTER procedure [dbo].[Msg_ActivaServicioClave]
--int idtipomail, string idusuario, int idempresa, string clave
@IdTipoMail int,
@IdUsuario varchar(35),
@IdEmpresa int,
@Clave varchar(250)
AS 
BEGIN

DECLARE @IdTipoMailDiferenciado INT;
SET @IdTipoMailDiferenciado = @IdTipoMail;
BEGIN TRY  
	SET @IdTipoMailDiferenciado = dbo.Get_Mail_Diferenciado(@IdEmpresa, @IdTipoMail);
END TRY  
BEGIN CATCH  
	SET @IdTipoMailDiferenciado = @IdTipoMail;
END CATCH

DECLARE @Mensaje XML 
declare @XMLMensaje table
(
[IdTipoMail] int, 
[IdUsuario] varchar(35), 
[IdEmpresa] int, 
[Clave] varchar(250)
)

INSERT INTO @XMLMensaje 
( 
[IdTipoMail] , 
[IdUsuario] , 
[IdEmpresa] , 
[Clave] 
) 
VALUES ( 
@IdTipoMailDiferenciado ,
@IdUsuario,
@IdEmpresa ,
@Clave 
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 
DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE UsrCambiaClaveServ TO 
	SERVICE 'UsrCambiaClaveServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end
