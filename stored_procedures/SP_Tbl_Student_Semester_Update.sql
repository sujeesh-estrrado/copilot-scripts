IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Semester_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Student_Semester_Update]  
@Candidate_Id bigint,  
@Duration_Mapping_Id bigint  
AS  
BEGIN  
UPDATE Tbl_Student_Semester  
Set Duration_Mapping_Id=@Duration_Mapping_Id  
WHERE Candidate_Id=@Candidate_Id and Student_Semester_Current_Status=1  
END

    ')
END;
