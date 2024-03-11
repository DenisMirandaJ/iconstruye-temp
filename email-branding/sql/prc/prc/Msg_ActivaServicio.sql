USE [ColaboracionMensajeria2]
GO
/****** Object:  StoredProcedure [dbo].[Msg_ActivaServicio]    Script Date: 3/11/2024 12:07:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Msg_ActivaServicio]
    @idempresa  INT,
    @idorgc     INT,
    @iddoc      INT,
    @idLinea    INT,
    @idtipomail INT
AS
    BEGIN

		DECLARE @IdTipoMailDiferenciado INT;
        EXEC dbo.Get_Mail_Diferenciado @IdEmpresa, @IdTipoMail, @IdTipoMailDiferenciado OUTPUT;
        IF @IdTipoMailDiferenciado IS NULL
        BEGIN
            SET @IdTipoMailDiferenciado = @IdTipoMail; 
        END

        DECLARE @Mensaje XML;

        DECLARE @XMLMensaje TABLE
            (
                [idempresa]  INT,
                [idorgc]     INT,
                [iddoc]      INT,
                [idtipomail] INT,
                [idLinea]    INT
            );

        INSERT INTO @XMLMensaje
            (
                [idempresa],
                [idorgc],
                [iddoc],
                [idtipomail],
                [idLinea]
            )
        VALUES ( @idempresa, @idorgc, @iddoc, @IdTipoMailDiferenciado, @idLinea );
		PRINT @IdTipoMailDiferenciado;


        SELECT @Mensaje =
            (
                SELECT *
                FROM @XMLMensaje
                FOR XML PATH('param'), TYPE
            );



        DECLARE @Handle UNIQUEIDENTIFIER;



        -- Nuevos Mail Notificación Utilizarán solo una cola y servcio   


        IF @idtipomail = 97 --Aviso Modificación Linea Convenio        

           OR @idtipomail = 98 --Rechazo Modificación Linea Convenio        

           OR @idtipomail = 99 --Aprobación Modificación Linea Convenio        


            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE NotificacionServ
                TO SERVICE 'NotificacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;







        IF @idtipomail = 70 --Aviso Envío PE         

           OR @idtipomail = 74 --Rechazo PE        

           OR @idtipomail = 73 --Notificacion Super Administrador        

           OR @idtipomail = 75 --Aprobacion PE        

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE NotificacionServ
                TO SERVICE 'NotificacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;


        IF @idtipomail = 6501
           OR @idtipomail = 6502 --Notificacion Contralor Partes Relacionadas  
      BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE NotificacionServ
                TO SERVICE 'NotificacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;







        -- Dialog Conversation starts here           

        IF @idtipomail = 27 --27 ct_cierre          

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE CotizacionCierreServ
                TO SERVICE 'CotizacionCierreServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        /*          

if @idtipomail in (25,26) --ct          

begin          

 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CotizacionPubModServ TO           

 SERVICE 'CotizacionPubModServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;           

 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;           

 return           

end          

*/



        IF @idtipomail IN (65, 66) --pi          

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE PreingresoApruebaRechazoServ
                TO SERVICE 'PreingresoApruebaRechazoServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail IN (67, 78, 79, 116) --ep              

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE EstadoPagoServ
                TO SERVICE 'EstadoPagoServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 47 --regularizacion          

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE RegularizacionServ
                TO SERVICE 'RegularizacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail IN (45, 41, 43, 39, 46)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE PedidoMaterialesServ
                TO SERVICE 'PedidoMaterialesServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 44
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE PmNotificaSuperAdminServ
                TO SERVICE 'PmNotificaSuperAdminServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail IN (20, 42)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE OC_AvisoServ
                TO SERVICE 'OC_AvisoServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;





        IF @idtipomail IN (21, 22)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE Oc_EnvioaAprobacionServ
                TO SERVICE 'Oc_EnvioaAprobacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail IN (23, 36, 34, 32, 35)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE OcServ
                TO SERVICE 'OcServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 24
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE OCRechazadaAprobadorServ
                TO SERVICE 'OCRechazadaAprobadorServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        /*          

if @idtipomail =37          

begin           

 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE OCSolicitudCancelacionServ TO           

 SERVICE 'OCSolicitudCancelacionServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;           

 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;           

 return          

end          

*/

        IF @idtipomail IN (48, 52)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE FACEnvioaAprobacionServ
                TO SERVICE 'FACEnvioaAprobacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 49
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE FACAprobadaServ
                TO SERVICE 'FACAprobadaServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 50
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE FACRechazadaServ
                TO SERVICE 'FACRechazadaServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        /*          

if @idtipomail =51  -- BD_Recepciones_con_Rechazo           

begin           

 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE FACRechazadaServ TO           

 SERVICE 'RecepcionRechazoServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;           

 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;           

 return          

end          

*/

        IF @idtipomail IN (61, 62)
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE SCEnvioaAprobacionServ
                TO SERVICE 'SCEnvioaAprobacionServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 63
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE SCAprobacionTotalServ
                TO SERVICE 'SCAprobacionTotalServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;





        IF @idtipomail = 106 --Receptor mensajeria SC           

            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE SCReceptorMesajeriaServ
                TO SERVICE 'SCReceptorMesajeriaServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;



        IF @idtipomail = 64
            BEGIN

                BEGIN DIALOG CONVERSATION @Handle
                FROM SERVICE SCRechazadaAprobadorServ
                TO SERVICE 'SCRechazadaAprobadorServ'
                ON CONTRACT [Contrato_Msg]
                WITH ENCRYPTION = OFF;

                SEND ON CONVERSATION @Handle
                MESSAGE TYPE MsgIC
                (@Mensaje);

                RETURN;

            END;

    END;



IF @idtipomail = 87
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE [CancelacionFacturaServ]
        TO SERVICE 'CancelacionFacturaServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;



IF @idtipomail = 88
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE [CancelacionNotaCorreccionServ]
        TO SERVICE 'CancelacionNotaCorreccionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;





IF @idtipomail IN (126)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE OC_RechazaAdjudicacionServ
        TO SERVICE 'OC_RechazaAdjudicacionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;



IF @idtipomail IN (131, 132, 133, 134, 135, 136)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE SA_Serv
        TO SERVICE 'SA_Serv'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;





IF @idtipomail IN (131, 132, 133, 134, 135, 136)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE SA_Serv
        TO SERVICE 'SA_Serv'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;


IF @idtipomail IN (200)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE Oc_EnvioaAprobacionServ
        TO SERVICE 'Oc_EnvioaAprobacionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;

IF @idtipomail IN (201)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE SCEnvioaAprobacionServ
        TO SERVICE 'SCEnvioaAprobacionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;
		

if @idtipomail in(80)              
	begin                 

		 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE EPEnvioaAprobacionServ TO                 

		 SERVICE 'EPEnvioaAprobacionServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                 

		 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                 

		 return                

	end     

if @idtipomail in (118,119)                  
	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CCOMP_EnvioaAprobacionServ TO                   

	 SERVICE 'CCOMP_EnvioaAprobacionServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                   

	end  


if @idtipomail = 120                  

	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CCOMPServ TO                   

	SERVICE 'CCOMPServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                  

	end  


if @idtipomail = 121                  

	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE CCOMPRechazadaAprobadorServ TO                   

	 SERVICE 'CCOMPRechazadaAprobadorServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                  

	end   	
	
	
if @idtipomail in (122,123)                  

	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BH_EnvioaAprobacionServ TO                   

	 SERVICE 'BH_EnvioaAprobacionServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                   

	end                   

                  

if @idtipomail = 124                

	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BHServ TO                   

	 SERVICE 'BHPServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                  

	end                  

                  

if @idtipomail = 125                  

	begin                   

	 BEGIN DIALOG CONVERSATION @Handle FROM SERVICE BHRechazadaAprobadorServ TO                   

	 SERVICE 'BHRechazadaAprobadorServ' ON CONTRACT [Contrato_Msg] WITH ENCRYPTION = OFF ;                   

	 SEND ON CONVERSATION @Handle MESSAGE TYPE MsgIC (@Mensaje) ;                   

	 return                  

	end       

IF @idtipomail IN (131, 132, 133, 134, 135, 136)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE SA_Serv
        TO SERVICE 'SA_Serv'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;


IF @idtipomail IN (200)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE Oc_EnvioaAprobacionServ
        TO SERVICE 'Oc_EnvioaAprobacionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

    END;

IF @idtipomail IN (201)
    BEGIN

        BEGIN DIALOG CONVERSATION @Handle
        FROM SERVICE SCEnvioaAprobacionServ
        TO SERVICE 'SCEnvioaAprobacionServ'
        ON CONTRACT [Contrato_Msg]
        WITH ENCRYPTION = OFF;

        SEND ON CONVERSATION @Handle
        MESSAGE TYPE MsgIC
        (@Mensaje);

        RETURN;

	END;
END;