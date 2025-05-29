IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_duration_by_course_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
	CREATE procedure [dbo].[Sp_Get_duration_by_course_Master] (@courseid bigint =0,@masterid bigint=0)
as
begin
select  DATEDIFF(dd, 0,Exam_Date) + CONVERT(DATETIME,Exam_Time_From) as Fromdate,
DATEDIFF(dd, 0,Exam_Date) + CONVERT(DATETIME,Exam_Time_To) as Todate from

Tbl_Exam_Schedule where Course_id=@courseid and Exam_Schedule_Id=@masterid and Exam_Schedule_Status=0
end
'
	
	);
END;
