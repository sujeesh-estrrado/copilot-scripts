IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Load_Absent_student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Load_Absent_student]

@Candidate_Id bigint,
@Subject_Id bigint,
@Class_Timings_Id bigint,
@Absent_Date datetime
as
begin

    select Absent_Type=''absent'' from dbo.Tbl_Student_Absence where Subject_Id=@Subject_Id and Candidate_Id=@Candidate_Id and Class_Timings_Id=@Class_Timings_Id and Absent_Date=@Absent_Date
  
end
  --select Absent_Type=''absent'' from dbo.Tbl_Student_Absence where Subject_Id=4 and Candidate_Id=120 and Class_Timings_Id=43 and Absent_Date=''''2016-02-22 00:00:00.000''''''
    ')
END;
