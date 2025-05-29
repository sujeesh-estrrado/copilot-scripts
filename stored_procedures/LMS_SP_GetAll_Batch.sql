IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_AssignCriteria]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_AssignCriteria]

AS

BEGIN


--SELECT ID,CourseID,CriteriaID,[Year],Del_Status
--		FROM [dbo].[Tbl_AssignCriteria]  



SELECT     a.ID, a.CourseID, a.CriteriaID, a.[Year],
		   b.ID AS Crit_ID, b.Total_CutOff, b.Subj1_CutOff, b.Subj2_CutOff, b.Subj3_CutOff,
		   c.Course_Category_Name
	FROM   dbo.Tbl_AssignCriteria AS a 
		INNER JOIN  dbo.Tbl_SelectionCriteria AS b ON a.CriteriaID = b.ID 
		INNER JOIN  dbo.Tbl_Course_Category AS c ON a.CourseID = c.Course_Category_Id
	WHERE (c.Course_Category_Status = 0) AND (a.Del_Status = 0) AND (b.DelStatus = 0)




END

    
    ')
END
GO
