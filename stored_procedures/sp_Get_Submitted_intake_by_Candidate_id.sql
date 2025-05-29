IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Submitted_intake_by_Candidate_id]')
    AND type = N'P'
)
BEGIN
    EXEC(N'
    CREATE procedure [dbo].[sp_Get_Submitted_intake_by_Candidate_id](@candidate_id bigint,@flag bigint)
as
begin

if(@flag=1)
begin
SELECT        dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID, dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode, dbo.Tbl_Course_Batch_Duration.Batch_From, dbo.Tbl_Course_Batch_Duration.Batch_To, 
                         dbo.Tbl_Department.Department_Id, dbo.Tbl_Department.Department_Name AS CategoryName, dbo.Tbl_Course_Batch_Duration.Study_Mode, dbo.Tbl_Course_Batch_Duration.Batch_Id, 
                         dbo.Tbl_Course_Batch_Duration.Org_Id, dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_Category_Name, CONCAT(dbo.Tbl_Department.Department_Id,''#'',dbo.Tbl_Course_Batch_Duration.Batch_Id)AS PgmBatch
FROM            dbo.tbl_New_Admission INNER JOIN
                         dbo.Tbl_Candidate_Personal_Det ON dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.New_Admission_Id INNER JOIN
                         dbo.Tbl_Course_Batch_Duration INNER JOIN
                         dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id INNER JOIN
                         dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id INNER JOIN
                         dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN
                         dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id ON 
                         dbo.tbl_New_Admission.Department_Id = dbo.Tbl_Course_Batch_Duration.Duration_Id AND dbo.tbl_New_Admission.Batch_Id = dbo.Tbl_Course_Batch_Duration.Batch_Id
                         where Candidate_Id=@candidate_id


                         end
                         if(@flag=2)
                         begin

                         SELECT        dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID, dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode, dbo.Tbl_Course_Batch_Duration.Batch_From, dbo.Tbl_Course_Batch_Duration.Batch_To, 
                         dbo.Tbl_Department.Department_Id, dbo.Tbl_Department.Department_Name AS CategoryName, dbo.Tbl_Course_Batch_Duration.Study_Mode, dbo.Tbl_Course_Batch_Duration.Batch_Id, 
                         dbo.Tbl_Course_Batch_Duration.Org_Id, dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_Category_Name,CONCAT(dbo.Tbl_Department.Department_Id, ''#'',dbo.Tbl_Course_Batch_Duration.Batch_Id) AS PgmBatch
FROM            dbo.tbl_New_Admission INNER JOIN
                         dbo.Tbl_Course_Batch_Duration INNER JOIN
                         dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id INNER JOIN
                         dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id INNER JOIN
                         dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN
                         dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id ON 
                         dbo.tbl_New_Admission.Department_Id = dbo.Tbl_Course_Batch_Duration.Duration_Id AND dbo.tbl_New_Admission.Batch_Id = dbo.Tbl_Course_Batch_Duration.Batch_Id INNER JOIN
                         dbo.Tbl_Candidate_Personal_Det ON dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option2
                         where Candidate_Id=@candidate_id

                         end

                         if(@flag=3)
                         begin
                         SELECT        dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID, dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode, dbo.Tbl_Course_Batch_Duration.Batch_From, dbo.Tbl_Course_Batch_Duration.Batch_To, 
                         dbo.Tbl_Department.Department_Id, dbo.Tbl_Department.Department_Name AS CategoryName, dbo.Tbl_Course_Batch_Duration.Study_Mode, dbo.Tbl_Course_Batch_Duration.Batch_Id, 
                         dbo.Tbl_Course_Batch_Duration.Org_Id, dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_Category_Name, CONCAT(dbo.Tbl_Department.Department_Id, ''#'', 
                         dbo.Tbl_Course_Batch_Duration.Batch_Id)AS PgmBatch
FROM            dbo.tbl_New_Admission INNER JOIN
                         dbo.Tbl_Course_Batch_Duration INNER JOIN
                         dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id INNER JOIN
                         dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id INNER JOIN
                         dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN
                         dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id ON 
                         dbo.tbl_New_Admission.Department_Id = dbo.Tbl_Course_Batch_Duration.Duration_Id AND dbo.tbl_New_Admission.Batch_Id = dbo.Tbl_Course_Batch_Duration.Batch_Id INNER JOIN
                         dbo.Tbl_Candidate_Personal_Det ON dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option3   where Candidate_Id=@candidate_id
                         end

                         end
    ');
END;
