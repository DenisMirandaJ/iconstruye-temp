USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioMensajeriaProveedor]    Script Date: 3/11/2024 9:45:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 7

ALTER procedure [dbo].[msg_ActivaServicioMensajeriaProveedor]
@IdEmpresa int,
@IdOrgc int,
@Iddoc int,
@idempresaventa int,
@Idorgv int,
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
[idempresa] int, 
[idorgc] INT, 
[iddoc] int, 
[IdEmpresav] int, 
[Idorgv] int, 
[IdUsuarioDes] varchar(30),
[idtipomail] int
)

INSERT INTO @XMLMensaje 
( 
[idempresa] , 
[idorgc] , 
[iddoc] , 
[IdEmpresav],
[Idorgv],
[IdUsuarioDes] ,
[idtipomail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@Iddoc ,
@idempresaventa,
@Idorgv,
@IdUsuarioDes ,
@IdTipoMailDiferenciado 
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 

select @Mensaje

DECLARE @Handle UNIQUEIDENTIFIER ;

if @idtipomail = 84
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [AprobacionFacturaProveedorServ] TO 
	SERVICE 'AprobacionFacturaProveedorServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end

if @idtipomail in (25,26) --ct
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CotizacionPubModServ TO 
	SERVICE 'CotizacionPubModServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end

if @idtipomail = 85
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [SolicitudNotaCorreccionProveedorServ] TO 
	SERVICE 'SolicitudNotaCorreccionProveedorServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end

if @idtipomail = 86
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [CancelacionNotaCorreccionProveedorServ] TO 
	SERVICE 'CancelacionNotaCorreccionProveedorServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end

if @idtipomail =51  -- BD_Recepciones_con_Rechazo 
begin 
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE FACRechazadaServ TO 
	SERVICE 'RecepcionRechazoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return
end

if @idtipomail =37
begin 
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE OCSolicitudCancelacionServ TO 
	SERVICE 'OCSolicitudCancelacionServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return
end

if @idtipomail in (20,42)
begin 
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE OC_AvisoServ TO 
	SERVICE 'OC_AvisoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end


END
