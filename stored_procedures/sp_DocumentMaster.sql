IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_DocumentMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_DocumentMaster] --7,''Lab Result''  
        (  
            @flag INT = 0,  
            @Document_Name VARCHAR(MAX) = '''',  
            @Type_of_student VARCHAR(100) = '''',  
            @Category_id BIGINT = 0,  
            --@Delete_Status BIT = 0,  
            @Doc_ID BIGINT = 0  
        )  
        AS  
        BEGIN  
            IF(@flag = 1) -- Insert New Document Master  
            BEGIN  
                IF NOT EXISTS (  
                    SELECT Document_Name  
                    FROM tbl_certificate_master  
                    WHERE Document_Name = @Document_Name 
                    AND Type_of_student = @Type_of_student 
                    AND Delete_Status = 0 
                )  
                BEGIN  
                    INSERT INTO [dbo].[tbl_certificate_master]  
                        ([Document_Name], [Type_of_student], Category_id, Delete_Status, StaticDoc)  
                    VALUES  
                        (@Document_Name, @Type_of_student, @Category_id, 0, 0)  
                END  
            END  

            IF(@flag = 2) -- Check Existence  
            BEGIN  
                SELECT *   
                FROM tbl_certificate_master   
                WHERE Document_Name = @Document_Name  
                AND Type_of_student = @Type_of_student  
                AND Delete_Status = 0  
            END  

            IF(@flag = 3) -- Select All Active Documents  
            BEGIN  
                SELECT  
                    tbl_certificate_master.id AS Doc_ID,  
                    Document_Name,  
                    Type_of_student,  
                    StaticDoc,  
                    tbl_certificate_master.Delete_Status,  
                    Category_id,  
                    tbl_certificate_category.category  
                FROM tbl_certificate_master  
                LEFT JOIN tbl_certificate_category  
                    ON tbl_certificate_category.id = tbl_certificate_master.Category_id  
                WHERE tbl_certificate_master.Delete_Status = 0  
                    AND (tbl_certificate_master.id = @Doc_ID OR @Doc_ID = 0)  
                    AND (Type_of_student = @Type_of_student OR @Type_of_student = '''')  
                    AND (StaticDoc = 0 OR StaticDoc IS NULL)  
            END  

            IF(@flag = 4) -- Update Master Document  
            BEGIN  
                UPDATE tbl_certificate_master  
                SET Document_Name = @Document_Name,  
                    Type_of_student = @Type_of_student,  
                    Category_id = @Category_id  
                WHERE Delete_Status = 0 AND id = @Doc_ID  
            END  

            IF(@flag = 5) -- Delete Document from Master Document  
            BEGIN  
                UPDATE tbl_certificate_master  
                SET Delete_Status = 1  
                WHERE id = @Doc_ID  
                    AND (StaticDoc != 1 OR StaticDoc IS NULL)  
            END  

            IF(@flag = 6) -- Select All Static Documents  
            BEGIN  
                SELECT  
                    id AS Doc_ID,  
                    Document_Name,  
                    Type_of_student,  
                    StaticDoc,  
                    Delete_Status,  
                    Category_id  
                FROM tbl_certificate_master  
                WHERE Delete_Status = 0  
                    AND (id = @Doc_ID OR @Doc_ID = 0)  
                    AND (Type_of_student = @Type_of_student OR @Type_of_student = '''' OR Type_of_student IS NULL)  
                    AND (StaticDoc = 1)  
            END  

            IF(@flag = 7) -- Select All Documents  
            BEGIN  
                SELECT *   
                FROM tbl_certificate_master   
                WHERE Document_Name = @Document_Name  
                    AND Delete_Status = 0  
            END  
        END  
    ')
END
