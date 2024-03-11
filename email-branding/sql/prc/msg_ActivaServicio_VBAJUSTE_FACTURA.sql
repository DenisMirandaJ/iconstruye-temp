USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicio_VBAJUSTE_FACTURA]    Script Date: 3/11/2024 9:41:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicio_VBAJUSTE_FACTURA]  
@IdEmpresa int,  
@IdOrgc int,  
@IdDoc int,  
@IdUsuario varchar(30),  
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
[IdUsuario] varchar(30),  
[IdTipoMail] int  
)  
  
INSERT INTO @XMLMensaje   
(   
[IdEmpresa] ,   
[IdOrgc] ,   
[IdDoc] ,   
[IdUsuario] ,  
[IdTipoMail]   
)   
VALUES (   
@IdEmpresa ,  
@IdOrgc ,  
@IdDoc ,  
@IdUsuario ,  
@IdTipoMailDiferenciado   
)   
  
SELECT @Mensaje = ( SELECT * FROM @XMLMensaje  
FOR XML PATH('param'),   
TYPE   
) ;   
  
select @Mensaje  
  
DECLARE @Handle UNIQUEIDENTIFIER ;   
begin  
 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE VBAJUSTE_FACTURA_Serv TO   
 SERVICE 'VBAJUSTE_FACTURA_Serv' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;   
 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;   
 return   
end  
end  
