-- 5

CREATE procedure [dbo].[msg_ActivaServicioCreacionBodegaSistema]
  @IdEmpresa int,
  @IdOrgc int,
  @IdBodega int,
  @IdUsuarioDes varchar(30),
  @IdTipoMail int
AS
BEGIN

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
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdBodega ,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE [BodegaCreacionBodegaSistemaServ] TO 
	SERVICE 'BodegaCreacionBodegaSistemaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end
