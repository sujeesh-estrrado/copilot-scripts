IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_All_Countries]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_All_Countries]    
as    
begin    
    
select * from Tbl_Nationality order by Nationality

--select Country as nationality,Country_Id as nationality_id from Tbl_Country  order by Country
 
    
    
end
    ')
END
