IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Nationality]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Proc_GetAll_Nationality]    
as    
begin    
    
select * from Tbl_Nationality   order by Nationality
  
end
    ')
END;
