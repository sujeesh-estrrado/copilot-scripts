IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_PrevEduStream_By_AdmissionId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_PrevEduStream_By_AdmissionId](@New_Admission_Id bigint)

AS
BEGIN


SELECT  a.New_Admission_Id,a.Previous_Stream_Id,ps.Previous_Stream_Name,
(select cl.Course_Level_Id from dbo.Tbl_Course_Level cl left join dbo.tbl_New_Admission n on 
n.Course_Level_Id=cl.Course_Level_Id where n.New_Admission_Id=a.New_Admission_Id) as AppliedCourseLevelID,

(select cc.Course_Category_Id from dbo.Tbl_Course_Category cc left join dbo.tbl_New_Admission n on 
n.Course_Category_Id=cc.Course_Category_Id where n.New_Admission_Id=a.New_Admission_Id) as AppliedCourseCategoryID,

(select cl.Course_Level_Name from dbo.Tbl_Course_Level cl left join dbo.tbl_New_Admission n on 
n.Course_Level_Id=cl.Course_Level_Id where n.New_Admission_Id=a.New_Admission_Id) as AppliedCourseLevel,

(select cc.Course_Category_Name from dbo.Tbl_Course_Category cc left join dbo.tbl_New_Admission n on 
n.Course_Category_Id=cc.Course_Category_Id where n.New_Admission_Id=a.New_Admission_Id) as AppliedCourseCategory,

ps.CourseLevel as PreviousCourseLevelID,ps.Category as PreviousCourseCategoryID,



(select Course_Level_Name from dbo.Tbl_Course_Level where Course_Level_Id=ps.CourseLevel) as PreviousCourseLevel,

(select Course_Category_Name from dbo.Tbl_Course_Category where Course_Category_Id=ps.Category) as PreviousCourseCategory



FROM Tbl_Admission_Previous_Stream_Mapping a left join Tbl_Previous_Stream ps on 

ps.Previous_Stream_Id=a.Previous_Stream_Id 

where a.New_Admission_Id=@New_Admission_Id
END

    ')
END
