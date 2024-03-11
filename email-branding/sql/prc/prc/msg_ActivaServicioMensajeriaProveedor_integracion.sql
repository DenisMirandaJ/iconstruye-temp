USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioMensajeriaProveedor_integracion]    Script Date: 3/11/2024 9:45:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicioMensajeriaProveedor_integracion]
(
@Iddoc int,
@IdTipoMail int,
@mailAlternativo varchar(100),
@encriptaData varchar(200)
)as
BEGIN 

DECLARE @Mensaje XML 

declare @XMLMensaje table([Iddoc] int, [IdTipoMail] int,[MailAlternativo] varchar(100),EncriptaData varchar(200))

INSERT INTO @XMLMensaje([Iddoc] ,[IdTipoMail] ,[MailAlternativo],[EncriptaData]) 
VALUES ( @Iddoc ,@IdTipoMail , @mailAlternativo,@encriptaData)

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ;
/*Servicio de Integracion*/
if @idtipomail = 90
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [servicioMsgIntegracion] TO 
	SERVICE 'servicioMsgIntegracion' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
END
