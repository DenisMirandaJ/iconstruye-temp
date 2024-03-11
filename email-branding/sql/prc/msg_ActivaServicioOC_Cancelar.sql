USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioOC_Cancelar]    Script Date: 3/11/2024 9:46:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicioOC_Cancelar]
 @IdEmpresa int,        
 @IdOrgc int,        
 @IdDoc int,  
 @IdUsuarioCancelaOC varchar(30), 
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
[IdUsuarioCancelaOC] varchar(30),
[IdUsuarioDes] varchar(30),
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa] , 
[IdOrgc] , 
[IdDoc] , 
[IdUsuarioCancelaOC],
[IdUsuarioDes] ,
[IdTipoMail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@IdDoc ,
@IdUsuarioCancelaOC,
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
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE OC_CancelarServ TO 
	SERVICE 'OC_CancelarServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end
