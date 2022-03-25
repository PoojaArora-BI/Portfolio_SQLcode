USE [AUS_Advance]
GO

/****** Object:  StoredProcedure [dbo].[spGeoDistance]    Script Date: 25/3/2022 12:57:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*Given Suburb and City, Display Transport witin 1km Radius */
CREATE PROCEDURE [dbo].[spGeoDistance]
( @subcity varchar(150),
  @distance int
 )
 AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @subgeo GEOGRAPHY, @sublat DECIMAL(8,6), @sublong DECIMAL(9,6);

		SELECT @sublat = [Latitude],
			   @sublong =[Longitude]
		FROM [AUS_Advance].[dbo].[DimGeography](NOLOCK)
		WHERE Suburb + '/' + City = @subcity;

		SET @subgeo = geography :: Point(@sublat, @sublong, 4326);

		SELECT [Stop_Name],
				[Mode],
		        ROUND((@subgeo.STDistance(geography::Point([Stop_Lat], [Stop_Lon], 4326)) / 1000), 2) AS [Distance(km)]
		FROM [AUS_Advance].[dbo].[DimStgTransport](NOLOCK)
		WHERE(@subgeo.STDistance(geography::Point([Stop_Lat], [Stop_Lon], 4326)) / 1000) <= @distance
		ORDER BY [Distance(km)];
   END;
GO


