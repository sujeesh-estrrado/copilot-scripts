IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_ATTENDANCE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DELETE_ATTENDANCE]    
@Absent_Date  datetime,          
@Duration_Mapping_Id bigint      
    
AS    
BEGIN    
DELETE FROM Tbl_Student_Absence    
WHERE Absent_Date=@Absent_Date and Duration_Mapping_Id=@Duration_Mapping_Id    
END
    ')
END
