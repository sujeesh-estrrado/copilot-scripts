IF NOT EXISTS (
SELECT 1 FROM sys.objects
    WHERE Organization_Id = @organization_id and object_id = OBJECT_ID(N'[dbo].[Check_exam_Overlap]',
@organization_id bigint
)
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Check_exam_Overlap]   --11,14159,''06/04/2020 00:00:00'',''06/04/2020 10:00:00'',''06/04/2020 14:00:00''

(
@masater_id bigint,
@course_id bigint  ,
@examdate datetime,
@from time(7),
@to Time(7)


)
as begin
 select * from Tbl_Exam_Schedule
 where
  Organization_Id = @organization_id and (Course_id !=@course_id or Exam_Master_Id!=@masater_id)
  and
  Exam_Date = @examdate
  and  (
    ( (cast(@from as time(0))) between Exam_Time_From and Exam_Time_To)  or
    (
     (
      (
       cast(@to as time(0)) between Exam_Time_From and Exam_Time_To
      )
      and
      (cast(@to as time(0)) != Exam_Time_From )
      or
      (
       Exam_Time_From>=(cast(@from as time(0))) and Exam_Time_To<=(cast(@to as time(0)))
      )
     )
    )
   )


  end
    ')
END
ELSE
BEGIN
EXEC('ALTER procedure Check_exam_Overlap

(
@masater_id bigint,
@course_id bigint  ,
@examdate datetime,
@from time(7),
@to Time(7)


)
as begin
 select * from Tbl_Exam_Schedule
 where
  Organization_Id = @organization_id and (Course_id !=@course_id or Exam_Master_Id!=@masater_id)
  and
  Exam_Date = @examdate
  and  (
    ( (cast(@from as time(0))) between Exam_Time_From and Exam_Time_To)  or
    (
     (
      (
       cast(@to as time(0)) between Exam_Time_From and Exam_Time_To
      )
      and
      (cast(@to as time(0)) != Exam_Time_From )
      or
      (
       Exam_Time_From>=(cast(@from as time(0))) and Exam_Time_To<=(cast(@to as time(0)))
      )
     )
    )
   )


  end


')
END