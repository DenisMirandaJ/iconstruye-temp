USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicioCreacionBodegaSistema]    Script Date: 3/11/2024 12:09:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 5

ALTER procedure [dbo].[msg_ActivaServicioCreacionBodegaSistema]
@IdEmpresa int,
@IdOrgc int,
@IdBodega int,
@IdUsuarioDes varchar(30),
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
[IdBodega] int, 
[IdUsuarioDes] varchar(30),
[IdTipoMail] int
)

INSERT INTO @XMLMensaje 
( 
[IdEmpresa] , 
[IdOrgc] , 
[IdBodega] , 
[IdUsuarioDes] ,
[IdTipoMail] 
) 
VALUES ( 
@IdEmpresa ,
@IdOrgc ,
@IdBodega ,
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
	BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [BodegaCreacionBodegaSistemaServ] TO 
	SERVICE 'BodegaCreacionBodegaSistemaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ; 
	SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ; 
	return 
end
end
