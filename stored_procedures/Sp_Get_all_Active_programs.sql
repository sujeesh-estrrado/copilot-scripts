IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_Active_programs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_Active_programs]
        (@FacultyId BIGINT,  
         @flag BIGINT = 0  
        )              
        AS              
        BEGIN   
            
            IF (@flag = 0)  
            BEGIN     
                IF (@FacultyId = 0)  
                BEGIN  
                    SELECT  
                        D.Department_Id, 
                        CONCAT(D.Department_Name, ''-'', D.Course_Code) AS Department_Name, 
                        D.Course_Code, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    WHERE D.Delete_Status = 0 
                      AND D.Active_Status = ''Active'' 
                    ORDER BY D.Department_Name;  
                END  
                ELSE  
                BEGIN   
                    SELECT  
                        D.Department_Id,
                        CONCAT(D.Department_Name, ''-'', D.Course_Code) AS Department_Name, 
                        D.Course_Code, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    WHERE CL.Course_Level_Id = @FacultyId 
                      AND D.Delete_Status = 0 
                      AND D.Active_Status = ''Active''  
                    ORDER BY D.Department_Name;  
                END  
            END  
            
            ELSE IF (@flag = 1) -- List all programs  
            BEGIN   
                IF (@FacultyId = 0)     
                BEGIN  
                    SELECT  
                        D.Department_Id,
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    ORDER BY D.Course_Code;  
                END  
                ELSE  
                BEGIN  
                    SELECT  
                        D.Department_Id,
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    WHERE CL.Course_Level_Id = @FacultyId  
                    ORDER BY D.Course_Code;  
                END  
            END      
            
            ELSE IF (@flag = 2)  
            BEGIN     
                IF (@FacultyId = 0)  
                BEGIN  
                    SELECT  
                        D.Department_Id, 
                        D.Department_Name, 
                        D.Course_Code, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS ProgrammeName, 
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    WHERE D.Delete_Status = 0 
                      AND D.Active_Status = ''Active'' 
                    ORDER BY D.Course_Code;  
                END  
                ELSE  
                BEGIN   
                    SELECT  
                        D.Department_Id, 
                        D.Department_Name, 
                        D.Course_Code, 
                        D.Intro_Date, 
                        CL.Course_Level_Name, 
                        D.Org_Id, 
                        D.Expiry_Date, 
                        CL.Course_Level_Id,   
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS ProgrammeName, 
                        D.Delete_Status  
                    FROM dbo.Tbl_Department AS D  
                    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
                        ON CL.Course_Level_Id = D.GraduationTypeId  
                    WHERE CL.Course_Level_Id = @FacultyId  
                      AND D.Delete_Status = 0 
                      AND D.Active_Status = ''Active''  
                    ORDER BY D.Course_Code;  
                END   
            END  
        END  
    ');
END;
