IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_tbl_certificate_category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_tbl_certificate_category]
            @flag BIGINT,
            @id BIGINT
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT * 
                FROM tbl_certificate_category 
                WHERE delete_status = 0;
            END
            
            IF (@flag = 1)
            BEGIN
                SELECT 
                    SDU.id,
                    CM.Document_Name AS CertificateTitle,
                    SDU.StudentId, 
                    SDU.DocumentName, 
                    SDU.DocumentLoc,
                    SDU.MarketingVerify,
                    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by, 
                    SDU.AdmissionVerify, 
                    CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by, 
                    SDU.CreatedDateDate, 
                    SDU.LastUpdated, 
                    SDU.DeleteStatus, 
                    CM.id AS CertificateID,
                    MarketingRejectionRemark,
                    AdmissionRejectionRemark
                FROM dbo.tbl_StudentDocUpload AS SDU
                INNER JOIN dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id
                LEFT OUTER JOIN dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id
                LEFT OUTER JOIN dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id
                WHERE (SDU.MarketingVerify != 0)
                    AND (SDU.DeleteStatus = 0)
                    AND (CM.Category_id = @id);
            END
            
            IF (@flag = 2)
            BEGIN
                SELECT * 
                FROM tbl_certificate_category 
                WHERE delete_status = 0 
                    AND id = @id;
            END
        END
    ')
END
