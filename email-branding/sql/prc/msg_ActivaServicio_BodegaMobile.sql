CREATE PROCEDURE msg_ActivaServicio_BodegaMobile
  @IdEmpresa		INT,
  @IdOrgc			INT,
  @IdDoc			INT,
  @IdUsuario		VARCHAR(30),
  @UsuarioDestino	VARCHAR(150),
  @IdTipoMail		INT
AS
BEGIN

  DECLARE @Mensaje XML

  DECLARE @XMLMensaje TABLE
            (
    [IdEmpresa] INT,
    [IdOrgc] INT,
    [IdDoc] INT,
    [IdUsuario] VARCHAR(30),
    [UsuarioDestino] VARCHAR(150),
    [IdTipoMail] INT
            )

  INSERT INTO @XMLMensaje
    (
    IdEmpresa,
    IdOrgc,
    IdDoc,
    IdUsuario,
    UsuarioDestino,
    IdTipoMail
    )
  VALUES
    ( @IdEmpresa, @IdOrgc, @IdDoc, @IdUsuario, @UsuarioDestino, @IdTipoMail )

  SELECT @Mensaje =
            (
                SELECT *
    FROM @XMLMensaje
    FOR XML PATH('param'), TYPE
            )

  --SELECT @Mensaje

  DECLARE @Handle UNIQUEIDENTIFIER
  BEGIN
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BodegaMobileServ TO 
            SERVICE 'BodegaMobileServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje)
    RETURN
  END
END