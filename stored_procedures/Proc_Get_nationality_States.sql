IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_nationality_States]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_nationality_States]   
@Nationality_id VARCHAR(MAX) 
as    
begin    
    
select * from [[Tbl_State]]]  where Nationality_Id=@Nationality_id
 

    
    
end

    ')
END