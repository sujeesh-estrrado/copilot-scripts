IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Counsellor_Bysettings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Counsellor_Bysettings]    
        (    
        @Page_Id bigint=0
        )    
        AS    
        BEGIN     
            SELECT Counsellor_Id, PageMapping_Id, 
                   CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS CounsellorName
            FROM Tbl_Counsellor_PageMapping PM
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = PM.Counsellor_Id
            WHERE E.Employee_Status = 0 
              AND PM.Delete_Status = 0 
              AND Page_Id = @Page_Id
        END
    ')
END
