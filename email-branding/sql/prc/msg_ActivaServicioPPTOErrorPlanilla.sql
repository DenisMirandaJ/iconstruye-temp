CREATE procedure [dbo].[msg_ActivaServicioPPTOErrorPlanilla]
  @IdEmpresa int,
  @IdOrgc int,
  @IdUsuarioDes varchar(30),
  @NombreArchivo varchar(200),
  @MailDestino varchar(150),
  @Recursos varchar(max),
  @IdTipoMail int
AS
BEGIN

  DECLARE @Mensaje XML

  declare @XMLMensaje table
(
    [IdEmpresa] int,
    [IdOrgc] INT,
    [IdUsuarioDes] varchar(30),
    [NombreArchivo] varchar(200),
    [MailDestino] varchar(150),
    [Recursos] varchar(max),
    [IdTipoMail] int
)

  INSERT INTO @XMLMensaje
    (
    [IdEmpresa],
    [IdOrgc],
    [IdUsuarioDes],
    [NombreArchivo],
    [MailDestino],
    [Recursos],
    [IdTipoMail]
    )
  VALUES
    (
      @IdEmpresa,
      @IdOrgc,
      @IdUsuarioDes,
      @NombreArchivo,
      @MailDestino,
      @Recursos,
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE PPTO_ErrorPlanillaServ TO 
	SERVICE 'PPTO_ErrorPlanillaServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end

