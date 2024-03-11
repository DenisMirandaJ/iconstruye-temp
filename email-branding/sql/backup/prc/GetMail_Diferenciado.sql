USE ColaboracionMensajeria2;
GO

CREATE FUNCTION dbo.Get_Mail_Diferenciado(
    @idempresa INT,
    @idtipomail INT
)
RETURNS INT
AS
BEGIN
    -- Flujo alterno para clientes con mail diferenciados
    DECLARE @IdTipoMailDiferenciado INT;
    DECLARE @IdSitioOrigen INT;
    DECLARE @GrupoMail INT;

    SET @IdTipoMailDiferenciado = @idtipomail;

    -- Obtener el sitio origen de la empresa
    SELECT @IdSitioOrigen = IdSitioOrigen
    FROM dbMarketPlace.dbo.EMPRESAS -- Linked Server
    WHERE idempresa = @idempresa;

    IF @IdSitioOrigen IS NULL
    BEGIN
        SET @IdSitioOrigen = 1; -- ASUMIMOS ICONSTRUYE
    END;

    IF @IdSitioOrigen != 1
    BEGIN
        -- Obtener el grupo mail del correo
        SELECT @GrupoMail = GRUPOMAIL
        FROM dbMarketPlace.dbo.MAIL
        WHERE IDMAIL = @idtipomail;

        -- Obtener el mail diferenciado
        SELECT @IdTipoMailDiferenciado = IDMAIL
        FROM dbMarketPlace.dbo.MAIL --Linked Server
        WHERE GRUPOMAIL = @GrupoMail AND IDSITIO = @IdSitioOrigen;

        IF @IdTipoMailDiferenciado IS NULL -- Si no existen mails diferenciados.
        BEGIN
            SET @IdTipoMailDiferenciado = @idtipomail;
        END
    END

    RETURN @IdTipoMailDiferenciado;

END;
GO