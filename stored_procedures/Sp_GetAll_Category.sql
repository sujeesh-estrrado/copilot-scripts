IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_Category]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_GetAll_Category]    
as    
begin    
    
select * from Tbl_Agent_Category where Active_Status=''Active'' and Delete_Status=0 
  
end
    ')
END
GO