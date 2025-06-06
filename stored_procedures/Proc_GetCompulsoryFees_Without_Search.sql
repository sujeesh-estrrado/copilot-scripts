-- Check if the stored procedure [dbo].[Proc_GetCompulsoryFees_Without_Search] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCompulsoryFees_Without_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetCompulsoryFees_Without_Search]  
        AS  
        BEGIN  
            SELECT ROW_NUMBER() OVER (ORDER BY CompulsoryFeeId DESC) AS num, Base.*  
            FROM (
                SELECT c.*, d.Department_Name, c.TypeOfStudent AS typestu 
                FROM dbo.Tbl_Fee_Compulsory c 
                INNER JOIN Tbl_Department d 
                ON d.Department_Id = c.CourseId
            ) Base
        END
    ')
END
