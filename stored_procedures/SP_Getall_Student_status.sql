IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Getall_Student_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE  procedure [dbo].[SP_Getall_Student_status]
AS      
BEGIN 
select * from Tbl_Student_status where active=1
end
    ')
END