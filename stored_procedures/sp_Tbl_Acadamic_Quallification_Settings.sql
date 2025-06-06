IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Tbl_Acadamic_Quallification_Settings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Tbl_Acadamic_Quallification_Settings]
            @flag BIGINT = 0,
            @Acadamic_settings_id BIGINT = 0,
            @faculty_id BIGINT = 0,
            @Secondary_Status BIT = 0,
            @Higher_Secondary_Status BIT = 0,
            @Additional_Qualification_Status BIT = 0
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT 
                    AQS.Acadamic_settings_id, 
                    AQS.Course_level_id, 
                    AQS.Secondary_Status, 
                    AQS.Higher_Secondary_Status, 
                    AQS.Additional_Qualification_Status, 
                    AQS.delete_status, 
                    AQS.created_date, 
                    CC.Course_Category_Name, 
                    CC.Program_Code
                FROM 
                    dbo.Tbl_Acadamic_Quallification_Settings AS AQS 
                INNER JOIN
                    dbo.Tbl_Course_Category AS CC 
                    ON AQS.Course_level_id = CC.Course_Category_Id
                WHERE 
                    (AQS.Acadamic_settings_id = @Acadamic_settings_id) 
                    AND (AQS.delete_status = 0) 
                    OR (AQS.delete_status = 0) 
                    AND (@Acadamic_settings_id = 0) 
                    AND (CC.Course_Category_Id = @faculty_id OR @faculty_id = 0)
            END

            IF (@flag = 1)
            BEGIN
                IF NOT EXISTS (SELECT * FROM Tbl_Acadamic_Quallification_Settings WHERE Course_level_id = @faculty_id AND delete_status = 0)
                BEGIN
                    INSERT INTO Tbl_Acadamic_Quallification_Settings 
                        (Course_level_id, Secondary_Status, Higher_Secondary_Status, Additional_Qualification_Status, created_date, delete_status) 
                    VALUES 
                        (@faculty_id, @Secondary_Status, @Higher_Secondary_Status, @Additional_Qualification_Status, GETDATE(), 0);
                END
            END

            IF (@flag = 2)
            BEGIN
                SELECT * FROM Tbl_Acadamic_Quallification_Settings WHERE delete_status = 0;
            END

            IF (@flag = 3) -- update table
            BEGIN
                UPDATE Tbl_Acadamic_Quallification_Settings 
                SET 
                    Secondary_Status = @Secondary_Status, 
                    Higher_Secondary_Status = @Higher_Secondary_Status, 
                    Additional_Qualification_Status = @Additional_Qualification_Status
                WHERE 
                    Course_level_id = @faculty_id;
            END

            IF (@flag = 4) -- delete with id
            BEGIN
                UPDATE Tbl_Acadamic_Quallification_Settings 
                SET 
                    delete_status = 1 
                WHERE 
                    Acadamic_settings_id = @Acadamic_settings_id;
            END

            IF (@flag = 5) -- select data with typeid
            BEGIN
                SELECT * FROM Tbl_Acadamic_Quallification_Settings WHERE Course_level_id = @faculty_id;
            END
        END
    ');
END
