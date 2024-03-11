USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioMensajeriaPM_CancelarPMCompleto]    Script Date: 3/11/2024 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[msg_ActivaServicioMensajeriaPM_CancelarPMCompleto]
 @IdEmpresa int,        
 @IdOrgc int,        
 @IdDoc int,  
 @IdUsuarioCancelaPM varchar(30), 
 @FechaCancelaPM varchar(10),
 @IdUsuarioDes varchar(30), 
 @IdTipoMail int 
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
[IdEmpresa] int, 
[IdOrgc] INT, 
[IdDoc] int, 
[IdUsuarioCancelaPM] varchar(30),
[FechaCancelaPM] varchar(10),
[IdUsuarioDes] varchar(30),
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa] , 
[IdOrgc] , 
[IdDoc] , 
[IdUsuarioCancelaPM] ,
[FechaCancelaPM] ,
[IdUsuarioDes] ,
[IdTipoMail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@IdDoc ,
@IdUsuarioCancelaPM ,
@FechaCancelaPM ,
@IdUsuarioDes ,
@IdTipoMailDiferenciado 
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PM_CancelarPMCompletoServ TO 
	SERVICE 'PM_CancelarPMCompletoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end
