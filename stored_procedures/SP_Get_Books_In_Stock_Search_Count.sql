IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Books_In_Stock_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Books_In_Stock_Search_Count]          
            @SearchTerm varchar(100)          
        AS          
        BEGIN          

            SELECT 
                ROW_NUMBER() OVER (ORDER BY B.Book_Id DESC) AS RowNumber,
                B.Book_Id AS ID,  
                B.Book_Title AS [Title],                                     
                B.Book_Serial_No AS [Serial No],       
                B.Book_Code AS [Code],    
                BC.Category_Name AS [Category],    
                BSC.SubCategory_Name AS [Sub-Category],    
                B.Book_Author AS [Author],    

                CASE 
                    WHEN B.Publisher_Id = 0 THEN ''Not Provided''   
                    ELSE (SELECT Publisher_Name FROM Tbl_Book_Publisher WHERE Publisher_Id = B.Publisher_Id) 
                END AS Publisher,

                CASE 
                    WHEN B.Almeria_Rack_Id = 0 THEN ''Not Provided''   
                    ELSE (SELECT Almeria_Rack_Name FROM Tbl_Book_Almeria_Rack WHERE Almeria_Rack_Id = B.Almeria_Rack_Id) 
                END AS Rack        
            FROM Tbl_AddBooks B            
            INNER JOIN Tbl_BookCategory BC ON B.Category_Id = BC.Category_Id              
            INNER JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id = BSC.SubCategory_Id              

            WHERE 
                B.Book_Id NOT IN (
                    (SELECT Book_Id FROM Tbl_LMS_Issue_Book WHERE Issue_Book_Status = 0 AND Is_Returned = 0)            
                    UNION 
                    (SELECT Book_Id FROM Tbl_LMS_Lost_Stolen_Book WHERE Lost_Stolen_Status = 0 AND Is_LostReturn = 0)            
                    UNION 
                    (SELECT Book_Id FROM Tbl_LMS_Book_Weeding WHERE Book_Weeding_Status = 0 AND Is_Returned = 0)
                )
                AND B.Book_Del_Status = 0

                AND (
                    B.Book_Title LIKE @SearchTerm + ''%''
                    OR B.Book_Serial_No LIKE @SearchTerm + ''%''
                    OR B.Book_Code LIKE @SearchTerm + ''%''
                    OR BC.Category_Name LIKE @SearchTerm + ''%''
                    OR BSC.SubCategory_Name LIKE @SearchTerm + ''%''
                    OR B.Book_Author LIKE @SearchTerm + ''%''
                    OR B.Publisher_Id LIKE @SearchTerm + ''%''
                )          
        END
    ')
END
