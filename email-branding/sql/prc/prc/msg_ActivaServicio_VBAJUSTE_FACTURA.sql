USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicio_VBAJUSTE_FACTURA]    Script Date: 3/11/2024 12:05:34 PM ******/
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
