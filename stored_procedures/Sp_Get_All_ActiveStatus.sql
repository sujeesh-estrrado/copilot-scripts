IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_ActiveStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       create procedure [dbo].[Sp_Get_All_ActiveStatus]
	
AS
BEGIN
	select id,name  from Tbl_Student_status
END

    ');
END;
