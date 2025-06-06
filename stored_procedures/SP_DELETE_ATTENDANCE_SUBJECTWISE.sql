IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_ATTENDANCE_SUBJECTWISE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DELETE_ATTENDANCE_SUBJECTWISE]
@Absent_Date  datetime,                
@Duration_Mapping_Id bigint  ,    
@Subject_Id bigint,          
@Class_Timings_Id bigint,
@CandidateId bigint,
@DeptId bigint ,
@EmployeeId bigint
AS          

BEGIN          
DELETE FROM Tbl_Student_Absence          
WHERE Absent_Date=@Absent_Date and Duration_Mapping_Id=@Duration_Mapping_Id and Subject_Id=@Subject_Id and Class_Timings_Id=@Class_Timings_Id
and Candidate_Id=@CandidateId and Course_Department_Id= @DeptId  and employee_Id  =@EmployeeId  


END
    ')
END
