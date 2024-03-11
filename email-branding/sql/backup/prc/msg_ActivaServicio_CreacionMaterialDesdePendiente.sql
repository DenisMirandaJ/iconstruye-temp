CREATE procedure [dbo].[msg_ActivaServicio_CreacionMaterialDesdePendiente]
  @IdEmpresa int,
  @IdPendiente int,
  @idMstrItem int,
  @IdTipoMail int
AS
BEGIN

  DECLARE @Mensaje XML

  declare @XMLMensaje table
(
    [IdEmpresa] int,
    [IdPendiente] int,
    [idMstrItem] int,
    [IdTipoMail] int
)

  INSERT INTO @XMLMensaje
    (
    IdEmpresa,
    IdPendiente,
    idMstrItem,
    IdTipoMail
    )
  VALUES
    (
      @IdEmpresa,
      @IdPendiente,
      @idMstrItem,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CreacionMaterialDesdePendienteServ TO 
	SERVICE 'CreacionMaterialDesdePendienteServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end
