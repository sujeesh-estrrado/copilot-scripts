IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Programs_By_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_Programs_By_Candidate]
    -- Add the parameters for the stored procedure here
    @Candidate_Id bigint
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    select (select Department_Name from Tbl_Department where Department_Id =  na.Department_Id) FirstChoice, 
     (select course_level_name from Tbl_Course_Level where Course_Level_Id = na.Course_level_id) FirstFaculty,

 (select Department_Name from Tbl_Department where Department_Id =  naa.Department_Id) SecondChoice, 
     (select course_level_name from Tbl_Course_Level where Course_Level_Id = naa.Course_level_id) SecondFaculty,

 (select Department_Name from Tbl_Department where Department_Id =  naaa.Department_Id) ThirdChoice,
     (select course_level_name from Tbl_Course_Level where Course_Level_Id = naa.Course_level_id) ThirdFaculty
from Tbl_Candidate_Personal_Det cpd 
left join tbl_New_Admission na on na.New_Admission_Id = cpd.New_Admission_Id
left join tbl_New_Admission naa on naa.New_Admission_Id = cpd.Option2
left join tbl_New_Admission naaa on naaa.New_Admission_Id = cpd.Option3
where cpd.Candidate_Id=@Candidate_Id
END
    ')
END
