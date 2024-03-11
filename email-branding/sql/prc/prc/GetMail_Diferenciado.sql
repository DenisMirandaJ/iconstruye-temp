USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[Get_Mail_Diferenciado]    Script Date: 3/11/2024 12:24:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Get_Mail_Diferenciado]
    @idempresa INT,
    @idtipomail INT,
    @IdTipoMailDiferenciado INT OUTPUT
AS
BEGIN
    -- Flujo alterno para clientes con mail diferenciados
    DECLARE @IdSitioOrigen INT;
    DECLARE @GrupoMail INT;

	SET @IdTipoMailDiferenciado = @idtipomail;

    -- Obtener el sitio origen de la empresa
    SELECT @IdSitioOrigen = IdSitioOrigen
    FROM ic..EMPRESAS -- Linked Server
    WHERE idempresa = @idempresa;

    IF @IdSitioOrigen IS NULL
    BEGIN
        SET @IdSitioOrigen = 1; -- ASUMIMOS ICONSTRUYE
    END;

    IF @IdSitioOrigen != 1
    BEGIN
        -- Obtener el grupo mail del correo
        SELECT @GrupoMail = GRUPOMAIL
        FROM ic..MAIL -- Linked Server
        WHERE IDMAIL = @idtipomail;

        -- Obtener el mail diferenciado
        SELECT @IdTipoMailDiferenciado = IDMAIL
        FROM ic..MAIL --Linked Server
        WHERE GRUPOMAIL = @GrupoMail AND IDSITIO = @IdSitioOrigen;

        IF @IdTipoMailDiferenciado IS NULL -- Si no existen mails diferenciados.
        BEGIN
            SET @IdTipoMailDiferenciado = @idtipomail;
        END
    END

    -- Output parameter to return the result
    SELECT @IdTipoMailDiferenciado AS IdTipoMailDiferenciado;
END;
