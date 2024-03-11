
CREATE procedure [dbo].[msg_ActivaServicioMensajeriaPM_CancelarPMCompleto]
  @IdEmpresa int,
  @IdOrgc int,
  @IdDoc int,
  @IdUsuarioCancelaPM varchar(30),
  @FechaCancelaPM varchar(10),
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
    [IdUsuarioCancelaPM] varchar(30),
    [FechaCancelaPM] varchar(10),
    [IdUsuarioDes] varchar(30),
    [IdTipoMail] int
)

  INSERT INTO @XMLMensaje
    (
    [IdEmpresa] ,
    [IdOrgc] ,
    [IdDoc] ,
    [IdUsuarioCancelaPM] ,
    [FechaCancelaPM] ,
    [IdUsuarioDes] ,
    [IdTipoMail]
    )
  VALUES
    (
      @IdEmpresa ,
      @IdOrgc ,
      @IdDoc ,
      @IdUsuarioCancelaPM ,
      @FechaCancelaPM ,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PM_CancelarPMCompletoServ TO 
	SERVICE 'PM_CancelarPMCompletoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end
