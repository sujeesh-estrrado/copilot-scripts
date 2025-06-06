IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteSemesterSubjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DeleteSemesterSubjects](@Duration_Mapping_Id bigint,@Department_Subjects_Id bigint)  
as  
begin  try
DELETE FROM Tbl_Semester_Subjects WHERE Duration_Mapping_Id=@Duration_Mapping_Id and Department_Subjects_Id=@Department_Subjects_Id  
 end try
begin catch
 RAISERROR(''Please delete Other References of Semester Subject'',16,1)
end catch
    ')
END
