CREATE procedure [dbo].[msg_ActivaServicioPM_CancelarLinea]
  @IdEmpresa int,
  @IdOrgc int,
  @IdDoc int,
  @IdLinea int,
  @IdUsuarioCancelaPM varchar(30),
  @IdUsuarioDes varchar(30),
  @IdTipoMail int
AS
BEGIN

  DECLARE @Mensaje XML

  declare @XMLMensaje table
(
    [IdEmpresa] int,
    [IdOrgc] INT,
    [IdDoc] int,
    [IdLinea] int,
    [IdUsuarioCancelaPM] varchar(30),
    [IdUsuarioDes] varchar(30),
    [IdTipoMail] int
)

  INSERT INTO @XMLMensaje
    (
    [IdEmpresa] ,
    [IdOrgc] ,
    [IdDoc] ,
    [IdLinea] ,
    [IdUsuarioCancelaPM] ,
    [IdUsuarioDes] ,
    [IdTipoMail]
    )
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdDoc ,
      @IdLinea ,
      @IdUsuarioCancelaPM ,
      @IdUsuarioDes ,
      @IdTipoMail 
)

  SELECT @Mensaje = ( SELECT *
    FROM @XMLMensaje
    FOR XML PATH('param'), 
TYPE 
)
  ;

  -- select @Mensaje

  DECLARE @Handle UNIQUEIDENTIFIER
  ;
  begin
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PM_CancelarLineaServ TO 
	SERVICE 'PM_CancelarLineaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end

