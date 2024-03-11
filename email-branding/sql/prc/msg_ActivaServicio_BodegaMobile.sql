USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[msg_ActivaServicio_BodegaMobile]    Script Date: 3/11/2024 9:40:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[msg_ActivaServicio_BodegaMobile]
    @IdEmpresa		INT,
    @IdOrgc			INT,
	@IdDoc			INT,
	@IdUsuario		VARCHAR(30),
	@UsuarioDestino	VARCHAR(150),
    @IdTipoMail		INT
AS
    BEGIN
		

		DECLARE @IdTipoMailDiferenciado INT;
		SET @IdTipoMailDiferenciado = @IdTipoMail;
		BEGIN TRY  
			SET @IdTipoMailDiferenciado = dbo.Get_Mail_Diferenciado(@IdEmpresa, @IdTipoMail);
		END TRY  
		BEGIN CATCH  
			SET @IdTipoMailDiferenciado = @IdTipoMail;
		END CATCH
		PRINT @IdTipoMailDiferenciado;
		

        DECLARE @Mensaje XML

        DECLARE @XMLMensaje TABLE
            (
                [IdEmpresa]			INT,
                [IdOrgc]			INT,
				[IdDoc]				INT,
				[IdUsuario]			VARCHAR(30),
				[UsuarioDestino]	VARCHAR(150),
                [IdTipoMail]		INT
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
        VALUES ( @IdEmpresa, @IdOrgc, @IdDoc, @IdUsuario, @UsuarioDestino, @IdTipoMailDiferenciado )

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