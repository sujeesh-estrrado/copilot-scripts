IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ModularStudent_List_PerClassSchedule]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ModularStudent_List_PerClassSchedule]
@Flag int 

AS
BEGIN

IF(@Flag = 1)
BEGIN
 SELECT CASE 
            WHEN Candidate_Id != 0 THEN ''Existing''
            ELSE ''New''
        END AS StudentStatus from Tbl_Modular_Candidate_Details
END

IF(@Flag = 2)
BEGIN
SELECT DISTINCT
TC.Country_Id ,
TC.Country AS Nationality  
FROM Tbl_Modular_Candidate_Details AS MCD
 LEFT JOIN Tbl_Candidate_Personal_Det AS cp ON cp.Candidate_Id = MCD.Candidate_Id
 LEFT JOIN Tbl_Country AS TC ON Country_Id = cp.Candidate_Nationality
END

IF(@Flag = 3)
BEGIN
SELECT DISTINCT
D.Department_Id ,
D.Department_Name AS Programme
FROM Tbl_Modular_Candidate_Details AS md
LEFT JOIN tbl_Modular_Courses AS mc ON mc.id = md.Modular_Course_Id
    LEFT JOIN Tbl_Candidate_Personal_Det AS cp ON cp.Candidate_Id = md.Candidate_Id
    LEFT JOIN tbl_New_Admission AS a ON cp.New_Admission_Id = a.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = a.Batch_Id 
    LEFT JOIN Tbl_Department AS D ON D.Department_Id = a.Department_Id

END

IF(@Flag = 4)
BEGIN
SELECT DISTINCT
BD.Batch_Id,
 BD.Batch_Code AS Intakeno
  FROM Tbl_Modular_Candidate_Details AS md
    LEFT JOIN tbl_Modular_Courses AS mc ON mc.id = md.Modular_Course_Id
    LEFT JOIN Tbl_Candidate_Personal_Det AS cp ON cp.Candidate_Id = md.Candidate_Id
    LEFT JOIN tbl_New_Admission AS a ON cp.New_Admission_Id = a.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = a.Batch_Id 
END

END
    ')
END;
