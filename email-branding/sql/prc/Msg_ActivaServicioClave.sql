--exec Msg_ActivaServicioClave 19,'Admin',9,'123456789'
CREATE procedure [dbo].[Msg_ActivaServicioClave]
  --int idtipomail, string idusuario, int idempresa, string clave
  @IdTipoMail int,
  @IdUsuario varchar(35),
  @IdEmpresa int,
  @Clave varchar(250)
AS
BEGIN

  DECLARE @Mensaje XML
  declare @XMLMensaje table
(
    [IdTipoMail] int,
    [IdUsuario] varchar(35),
    [IdEmpresa] int,
    [Clave] varchar(250)
)

  INSERT INTO @XMLMensaje
    (
    [IdTipoMail] ,
    [IdUsuario] ,
    [IdEmpresa] ,
    [Clave]
    )
  VALUES
    (
      @IdTipoMail ,
      @IdUsuario,
      @IdEmpresa ,
      @Clave 
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
    BEGIN DIALOG CONVERSATION @Handle FROM SERVICE UsrCambiaClaveServ TO 
	SERVICE 'UsrCambiaClaveServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;
    SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;
    return
  end
end
