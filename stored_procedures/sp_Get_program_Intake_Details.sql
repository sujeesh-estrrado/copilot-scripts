IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_program_Intake_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_program_Intake_Details]
(

@Semster_Subject_Id bigint ,
@Duration_Mapping_Id bigint=0,
@Department_Id bigint=0
)        
AS    
BEGIN 
  Select Distinct D.Department_Name AS program_name,
  IM.ID                    AS intake_id,
  BD.Batch_Code            AS intake ,
  CS.Semester_Id           AS Semester_Id,
  CS.Semester_Code         AS semester 
  from
  Tbl_Class_TimeTable CT
  INNER JOIN Tbl_Department						D   ON CT.Department_Id=D.Department_Id
  INNER JOIN Tbl_Course_Duration_PeriodDetails  CDP ON CT.Duration_Mapping_Id=CDP.Duration_Period_Id
  INNER JOIN Tbl_Course_Batch_Duration          BD  ON CDP.Batch_Id=BD.Batch_Id
  INNER JOIN dbo.Tbl_Course_Semester			CS  ON CS.Semester_Id = CDP.Semester_Id  
   inner join Tbl_IntakeMaster					IM  ON IM.Batch_Code=BD.Batch_Code

  where
  D.Department_Id=@Department_Id
  AND CDP.Duration_Period_Id=@Duration_Mapping_Id 


   
END
');
END;
