USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioMensajeriaPMPresupuestoExcedido]    Script Date: 3/11/2024 9:45:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[msg_ActivaServicioMensajeriaPMPresupuestoExcedido]
 @IdEmpresa int,        
 @IdOrgc int,        
 @IdDoc int,  
 @NomUsuarioRol varchar(100), 
 @MailUsuarioRol varchar(150),
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
[NomUsuarioRol] varchar(100),
[MailUsuarioRol] varchar(150),
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa] , 
[IdOrgc] , 
[IdDoc] , 
[NomUsuarioRol] , 
[MailUsuarioRol] ,
[IdTipoMail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@IdDoc ,
@NomUsuarioRol, 
@MailUsuarioRol,
@IdTipoMailDiferenciado 
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PM_PresupuestoExcedidoServ TO 
	SERVICE 'PM_PresupuestoExcedidoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end