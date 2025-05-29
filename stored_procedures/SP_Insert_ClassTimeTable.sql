IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ClassTimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Insert_ClassTimeTable]
    @Semster_Subject_Id BIGINT,
    @Duration_Mapping_Id BIGINT,
    @WeekDay_Settings_Id BIGINT,
    @Class_Timings_Id BIGINT,
    @Employee_Id BIGINT,
    @Day_Id BIGINT,
    @Department_Id BIGINT,
    @Location_Id BIGINT = 0
    --,@ReturnValue INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Tbl_Class_TimeTable
        (Semster_Subject_Id, Duration_Mapping_Id, WeekDay_Settings_Id, Class_Timings_Id, Employee_Id, Class_TimeTable_Status, Day_Id, Location_Id, Department_Id,Del_Status,merged_status)
    VALUES
        (@Semster_Subject_Id, @Duration_Mapping_Id, @WeekDay_Settings_Id, @Class_Timings_Id, @Employee_Id, 0, @Day_Id, @Location_Id, @Department_Id,0,0);

     

     --IF EXISTS (
  --      SELECT 1 
  --      FROM Tbl_Student_Absence 
  --      WHERE Course_Department_Id = @Department_Id 
  --        AND Duration_Mapping_Id = @Duration_Mapping_Id
  --        AND Subject_Id = @Semster_Subject_Id
  --        AND Class_Timings_Id = @Class_Timings_Id
  --        AND Employee_Id <> @Employee_Id 
  --  )
  --  BEGIN 
  --      UPDATE Tbl_Student_Absence
  --      SET Employee_Id = @Employee_Id
  --      WHERE Course_Department_Id = @Department_Id 
  --        AND Duration_Mapping_Id = @Duration_Mapping_Id
  --        AND Subject_Id = @Semster_Subject_Id
  --        AND Class_Timings_Id = @Class_Timings_Id;
  --  END

   
END;');
END;
