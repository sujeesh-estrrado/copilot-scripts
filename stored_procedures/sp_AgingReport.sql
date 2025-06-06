IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_AgingReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_AgingReport] --[sp_AgingReport] 57875            
        (            
        @Candidateid bigint = 0            
        )            
        AS            
        BEGIN   
             
            SELECT * FROM          
            (
                SELECT        
                    B.dateissue, 
                    B.docno, 
                    B.description, 
                    B.outstandingbalance, 
                    B.datedue,            
                    (SELECT DATEDIFF(DAY, B.dateissue, GETDATE()) AS DAYDIFF) AS AgingDays,             
                    BG.docno AS InvNo,            
                    CONCAT(CONVERT(date, B.dateissue),'' '', CONVERT(time, B.datecreated)) AS timec            
                FROM dbo.student_bill AS B 
                INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid            
                WHERE B.studentid = @Candidateid 
                  AND outstandingbalance > 0             
                  AND (SELECT DATEDIFF(DAY, B.dateissue, GETDATE()) AS DAYDIFF) >= 0            
                  AND B.billcancel = 0            
                  AND B.billid NOT IN ( 
                      SELECT billid           
                      FROM tbl_Installment_Bill_Details IBD                          
                      JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id                          
                      WHERE RI.Status = 1                          
                      AND RI.StudentID = @Candidateid    
                  )                    
            ) AS TblINV          
            UNION           
            (
                SELECT      
                    IB.dateissue, 
                    IB.docno, 
                    IB.description,
                    IB.outstandingbalance, 
                    IB.datedue,          
                    (SELECT DATEDIFF(DAY, IB.dateissue, GETDATE()) AS DAYDIFF) AS AgingDays, 
                    IB.docno AS InvNo,          
                    CONCAT(CONVERT(date, IB.dateissue),'' '', CONVERT(time, IB.datecreated)) AS timec            
                FROM Tbl_Installment_Bills IB                          
                JOIN tbl_Request_Installment RI ON IB.RefInstallmentId = RI.Id                          
                WHERE RI.Status = 1                          
                  AND RI.StudentID = @Candidateid           
                  AND IB.outstandingbalance > 0
            )          
        END
    ')
END
