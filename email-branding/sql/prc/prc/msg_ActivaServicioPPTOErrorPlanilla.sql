USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioPPTOErrorPlanilla]    Script Date: 3/11/2024 12:15:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicioPPTOErrorPlanilla]
 @IdEmpresa int,        
 @IdOrgc int,        
 @IdUsuarioDes varchar(30),
 @NombreArchivo varchar(200),
 @MailDestino varchar(150),
 @Recursos varchar(max),
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
[IdOrgc] INT, 
[IdUsuarioDes] varchar(30),
[NombreArchivo] varchar(200),
[MailDestino] varchar(150),
[Recursos] varchar(max),
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa], 
[IdOrgc], 
[IdUsuarioDes],
[NombreArchivo],
[MailDestino],
[Recursos],
[IdTipoMail]
) 
VALUES ( 
@IdEmpresa, 
@IdOrgc, 
@IdUsuarioDes,
@NombreArchivo,
@MailDestino,
@Recursos,
@IdTipoMailDiferenciado
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PPTO_ErrorPlanillaServ TO 
	SERVICE 'PPTO_ErrorPlanillaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end

