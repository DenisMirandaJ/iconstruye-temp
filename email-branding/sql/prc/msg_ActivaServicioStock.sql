CREATE procedure [dbo].[msg_ActivaServicioStock]
  @IdEmpresa int,
  @IdOrgc int,
  @IdBodega int,
  @Idmstritem int,
  @Saldo real,
  @StockCritico real,
  @IdTipoMail int
AS
BEGIN

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
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdBodega ,
      @Idmstritem ,
      @Saldo ,
      @StockCritico ,
      @IdTipoMail 
)

  SELECT @Mensaje = ( SELECT *
    FROM @XMLMensaje
    FOR XML PATH('param'), 
TYPE 
)
  ;
  DECLARE @Handle UNIQUEIDENTIFIER
  ;
  begin
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BodegaStokCriticoServ TO 
	SERVICE 'BodegaStokCriticoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end

--exec msg_ActivaServicioStock 11,1412,55,910057,55,56,82
