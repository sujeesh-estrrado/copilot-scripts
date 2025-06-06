IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Experience_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Experience_Insert]
        @Employee_Id BIGINT,
        @Employee_Experience_Pre_College_Name VARCHAR(500),
        @Employee_Duration_From DATETIME,
        @Employee_Duration_To DATETIME,
        @Employee_Desigination VARCHAR(50)
        AS
        BEGIN
            INSERT INTO dbo.Tbl_Employee_Experience (
                Employee_Id,
                Employee_Experience_Pre_College_Name,
                Employee_Duration_From,
                Employee_Duration_To,
                Employee_Desigination,
                Employee_Experience_Status
            ) 
            VALUES (
                @Employee_Id,
                @Employee_Experience_Pre_College_Name,
                @Employee_Duration_From,
                @Employee_Duration_To,
                @Employee_Desigination,
                0
            )
        END
    ')
END
