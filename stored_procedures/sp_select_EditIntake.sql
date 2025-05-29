IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_select_EditIntake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_select_EditIntake] 
(
@batchId int,@orgid int,@fromdate date,@enddate date,@studymode varchar(50)
)
as
begin
SELECT        dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID, dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode, Tbl_Course_Batch_Duration.Close_Date,
                         dbo.Tbl_Course_Batch_Duration.Batch_From, dbo.Tbl_Course_Batch_Duration.Batch_To, dbo.Tbl_Department.Department_Id, 
                         dbo.Tbl_Department.Department_Name AS CategoryName, dbo.Tbl_Course_Batch_Duration.Study_Mode, dbo.Tbl_Course_Batch_Duration.Batch_Id, 
                         dbo.Tbl_Course_Batch_Duration.Org_Id, dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_Category_Name,
                         CONCAT(dbo.Tbl_Department.Department_Id,''#'',dbo.Tbl_Course_Batch_Duration.Batch_Id) as PgmBatch 
FROM            dbo.Tbl_Course_Batch_Duration INNER JOIN
                         dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id INNER JOIN
                         dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id INNER JOIN
                         dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN
                         dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id 
						 and dbo.Tbl_Course_Category.Course_Category_Id=@batchId and  dbo.Tbl_Course_Batch_Duration.Org_Id=@orgid
						 and Batch_From between @fromdate and @enddate 
						 and Tbl_Course_Batch_Duration.Study_Mode=@studymode and Batch_DelStatus=0;
end
');
END;