USE dbMarketPlace;

GO

ALTER TABLE MAIL 
ADD IDSITIO tinyint  
DEFAULT 1 NOT NULL;

ALTER TABLE MAIL 
ADD CONSTRAINT FK_SITIO_ORIGEN 
FOREIGN KEY (IDSITIO) 
REFERENCES SitioOrigen(IdSitioOrigen);
GO