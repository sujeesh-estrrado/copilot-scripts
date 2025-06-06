IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GET_ALL_MODE]') 
    AND type = N'P'
)
BEGIN
    EXEC('

create PROCEDURE [dbo].[GET_ALL_MODE]--1,8
    -- Add the parameters for the stored procedure here
    (@flag bigint=0,@org_id bigint=0)
AS
BEGIN
--fOR ALL
    IF (@flag=0)
    BEGIN
    SELECT [Mode_ID] ,[MODE_CODE] ,[MODE]   ,[MODE_TYPE] FROM TBL_Mode
    END
    --fOR UG
    IF (@flag=1)
    BEGIN
    IF(@org_id=8)--Melaka
    BEGIN
    SELECT [Mode_ID] ,[MODE_CODE] ,[MODE]   ,[MODE_TYPE] FROM TBL_Mode WHERE  [MODE_TYPE] IN(0)
    END
    ELSE
    BEGIN
    SELECT [Mode_ID] ,[MODE_CODE] ,[MODE]   ,[MODE_TYPE] FROM TBL_Mode WHERE  [MODE_TYPE] IN(0,1,3)
    END

    END
    --fOR PG
    IF (@flag=2)
    BEGIN   
    SELECT [Mode_ID] ,[MODE_CODE] ,[MODE]   ,[MODE_TYPE] FROM TBL_Mode WHERE  [MODE_TYPE] IN(0,2,3) 
    END


    IF (@flag=3)
    BEGIN   
    SELECT [Mode_ID] ,[MODE_CODE] ,[MODE]   ,[MODE_TYPE] FROM TBL_Mode WHERE  [MODE_TYPE] IN(3) 
    END
END

    ')
END
