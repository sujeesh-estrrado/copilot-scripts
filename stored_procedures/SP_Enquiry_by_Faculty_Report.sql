IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Enquiry_by_Faculty_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Enquiry_by_Faculty_Report]        
            @flag BIGINT = 0,         
            @course_Level_id BIGINT = 0,      
            @fromdate DATETIME = NULL,          
            @Todate DATETIME = NULL         
        AS        
        BEGIN        
            IF (@flag = 0)                  
            BEGIN
                SELECT  
                    Cl.Course_Level_Id AS CID,
                    CL.Course_Level_Name AS CName,
                    COUNT(CPD.Event_Id) AS EVENTLEADS,
                    COUNT(CPD.Enquiry_From) AS INSTAPAGE,
                    COUNT(CPD.Online_OfflineStatus) AS ONLINEAPPLICATION 
                FROM 
                    Tbl_Candidate_Personal_Det CPD       
                LEFT JOIN 
                    tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id      
                RIGHT JOIN 
                    Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id      
                GROUP BY  
                    CL.Course_Level_Name, CL.Course_Level_Id
            END

            IF (@flag = 1)                  
            BEGIN             
                IF (@course_Level_id > 0)                  
                BEGIN            
                    SELECT  
                        Cl.Course_Level_Id AS CID,
                        CL.Course_Level_Name AS CName,
                        COUNT(CPD.Event_Id) AS EVENTLEADS,
                        COUNT(CPD.Enquiry_From) AS INSTAPAGE,
                        COUNT(CPD.Online_OfflineStatus) AS ONLINEAPPLICATION 
                    FROM 
                        Tbl_Candidate_Personal_Det CPD         
                    LEFT JOIN 
                        tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                    RIGHT JOIN 
                        Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id         
                    WHERE 
                        Cl.Course_Level_Id = @course_Level_id  
                        AND CPD.RegDate BETWEEN @fromdate AND @Todate        
                    GROUP BY  
                        CL.Course_Level_Name, CL.Course_Level_Id            
                END        
                ELSE        
                BEGIN        
                    SELECT  
                        Cl.Course_Level_Id AS CID,
                        CL.Course_Level_Name AS CName,
                        COUNT(CPD.Event_Id) AS EVENTLEADS,
                        COUNT(CPD.Enquiry_From) AS INSTAPAGE,
                        COUNT(CPD.Online_OfflineStatus) AS ONLINEAPPLICATION 
                    FROM 
                        Tbl_Candidate_Personal_Det CPD         
                    LEFT JOIN 
                        tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                    RIGHT JOIN 
                        Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id        
                    GROUP BY  
                        CL.Course_Level_Name, CL.Course_Level_Id          
                END
            END         
        END
    ')
END
