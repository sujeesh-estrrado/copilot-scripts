IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Event_Type]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create PROCEDURE [dbo].[Sp_Get_Event_Type]   
   
AS  
BEGIN  
select Distinct TypeOfEvent from Tbl_Event_Details   
END
    ')
END
