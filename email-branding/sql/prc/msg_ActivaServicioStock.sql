USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioStock]    Script Date: 3/11/2024 9:47:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[msg_ActivaServicioStock]
@IdEmpresa int,
@IdOrgc int,
@IdBodega int,
@Idmstritem int,
@Saldo real,
@StockCritico real,
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
[IdBodega] int, 
[Idmstritem] int,
[Saldo] real,
[StockCritico] real,
[IdTipoMail] int

)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa] , 
[IdOrgc] , 
[IdBodega] , 
[Idmstritem] ,
[Saldo] ,
[StockCritico] ,
[IdTipoMail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@IdBodega ,
@Idmstritem ,
@Saldo ,
@StockCritico ,
@IdTipoMailDiferenciado
) 

SELECT @Mensaje = ( SELECT * FROM @XMLMensaje
FOR XML PATH('param'), 
TYPE 
) ; 
DECLARE @Handle UNIQUEIDENTIFIER ; 
begin
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BodegaStokCriticoServ TO 
	SERVICE 'BodegaStokCriticoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end

--exec msg_ActivaServicioStock 11,1412,55,910057,55,56,82
