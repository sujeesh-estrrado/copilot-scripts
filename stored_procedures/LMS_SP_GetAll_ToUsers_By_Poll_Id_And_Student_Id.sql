IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_ToUsers_By_Poll_Id_And_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_ToUsers_By_Poll_Id_And_Student_Id]              
        @Poll_Id BIGINT,
        @Student_Id BIGINT 
        AS            
        BEGIN            
            SET NOCOUNT ON;

            SELECT DISTINCT    
                P.Poll_id,  
                CL.Class_Name AS [User]
            FROM dbo.LMS_Tbl_Poll P   
            INNER JOIN LMS_Tbl_Poll_Send PS 
                ON P.Poll_id = PS.Poll_Id  
            INNER JOIN LMS_Tbl_Class CL 
                ON CL.Class_Id = PS.Class_Id    
            WHERE PS.Poll_Id = @Poll_Id 
            AND PS.Class_Id IN (
                SELECT Class_Id 
                FROM LMS_Tbl_Student_Class 
                WHERE Student_id = @Student_Id
            );  
        END
    ')
END
