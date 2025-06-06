IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Initial_Application_registration_New_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Initial_Application_registration_New_By_Id]
        (
            @Intial_Application_Id Bigint
        )
        AS
        BEGIN
            SELECT
                dbo.Tbl_Initial_Application_Registration.Intial_Application_Id,
                dbo.Tbl_Initial_Application_Registration.Course_Level_Id,
                dbo.Tbl_Course_Level.Course_Level_Name, 
                dbo.Tbl_Initial_Application_Registration.Course_Category_Id,
                dbo.Tbl_Course_Category.Course_Category_Name,
                dbo.Tbl_Initial_Application_Registration.Department_Id,
                dbo.Tbl_Department.Department_Name,
                dbo.Tbl_Initial_Application_Registration.New_Admission_id,
                dbo.Tbl_Initial_Application_Registration.Name,
                dbo.Tbl_Initial_Application_Registration.DOB,
                dbo.Tbl_Initial_Application_Registration.Mobile,
                dbo.Tbl_Initial_Application_Registration.Email,
                dbo.Tbl_Initial_Application_Registration.Confirm_Email
            FROM dbo.Tbl_Initial_Application_Registration
            INNER JOIN dbo.Tbl_Course_Level ON dbo.Tbl_Initial_Application_Registration.Course_Level_Id = dbo.Tbl_Course_Level.Course_Level_Id
            INNER JOIN dbo.Tbl_Course_Category ON dbo.Tbl_Initial_Application_Registration.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
            INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Initial_Application_Registration.Department_Id = dbo.Tbl_Department.Department_Id
            WHERE dbo.Tbl_Initial_Application_Registration.Intial_Application_Id = @Intial_Application_Id
        END
    ')
END
