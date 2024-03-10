CREATE procedure [msg_ActivaServicio_VBAJUSTE_FACTURA]
  @IdEmpresa int,
  @IdOrgc int,
  @IdDoc int,
  @IdUsuario varchar(30),
  @IdTipoMail int
AS
BEGIN

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
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdDoc ,
      @IdUsuario ,
      @IdTipoMail   
)

  SELECT @Mensaje = ( SELECT *
    FROM @XMLMensaje
    FOR XML PATH('param'),   
TYPE   
)
  ;

  select @Mensaje

  DECLARE @Handle UNIQUEIDENTIFIER
  ;
  begin
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE VBAJUSTE_FACTURA_Serv TO   
 SERVICE 'VBAJUSTE_FACTURA_Serv' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end  
