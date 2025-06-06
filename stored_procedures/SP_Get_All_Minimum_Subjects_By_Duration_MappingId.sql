IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Minimum_Subjects_By_Duration_MappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Minimum_Subjects_By_Duration_MappingId]    
(@Duration_mapping_Id bigint)    
as    
begin    
    
    
select C.Minimum_Students,c.Course_Name,concat (c.Course_Name,''-'',C.Course_code) as code from Tbl_Semester_Subjects S    
inner join Tbl_New_Course C on C.Course_Id=S.Department_Subjects_Id    
where S.Duration_Mapping_Id=@Duration_mapping_Id    
end
    ')
END
