IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Nationality]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_Nationality] (    
@flag bigint=1)      
as        
begin     
 if @Flag=1            
 begin     
select Nationality_Id,Nationality from Tbl_Nationality     
end    
end     
    ')
END
