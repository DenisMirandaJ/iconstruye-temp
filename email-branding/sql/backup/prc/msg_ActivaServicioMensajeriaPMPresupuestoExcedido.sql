
CREATE procedure [dbo].[msg_ActivaServicioMensajeriaPMPresupuestoExcedido]
  @IdEmpresa int,
  @IdOrgc int,
  @IdDoc int,
  @NomUsuarioRol varchar(100),
  @MailUsuarioRol varchar(150),
  @IdTipoMail int
AS
BEGIN

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
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdDoc ,
      @NomUsuarioRol,
      @MailUsuarioRol,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PM_PresupuestoExcedidoServ TO 
	SERVICE 'PM_PresupuestoExcedidoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end