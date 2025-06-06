IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_SelectAllBadge]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_SelectAllBadge]
            @Class_Id BIGINT
        AS  
        BEGIN  
            SET NOCOUNT ON;

            SELECT  
                CB.Class_Badge_Id,
                B.Badge_Id, 
                B.Badge_Name, 
                B.Badge_Img  
            FROM LMS_Tbl_Class_Badge CB  
            INNER JOIN LMS_Tbl_Badge B 
                ON CB.Badge_Id = B.Badge_Id
            WHERE CB.Class_Id = @Class_Id;
        END
    ')
END;
