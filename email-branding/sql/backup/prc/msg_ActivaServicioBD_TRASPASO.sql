CREATE procedure [dbo].[msg_ActivaServicioBD_TRASPASO]
  @IdEmpresa int,
  @IdOrgc int,
  @IdDoc int,
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
    [IdUsuarioDes] varchar(30),
    [IdTipoMail] int
)

  INSERT INTO @XMLMensaje
    (
    [IdEmpresa] ,
    [IdOrgc] ,
    [IdDoc] ,
    [IdUsuarioDes] ,
    [IdTipoMail]
    )
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdDoc ,
      @IdUsuarioDes ,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BD_TRASPASOServ TO 
	SERVICE 'BD_TRASPASOServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end
