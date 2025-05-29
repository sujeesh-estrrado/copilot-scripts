IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Holidays]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Delete_Holidays](@Holiday_Id bigint)    
as    
begin    
    
DELETE  FROM Tbl_Holidays     
where Holiday_Id=@Holiday_Id    
    
    
--select * from Tbl_Leave_Holidays    
    
end


   ')
END;
