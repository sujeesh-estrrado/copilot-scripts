IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ExamAccessPrivilage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_ExamAccessPrivilage]
        (
            @flag bigint = 0,
            @roleid bigint = 0,
            @Page_Id bigint = 0,
            @Button_Id bigint = 0,
            @Buttonstatus bit = Null,
            @List_Id bigint = 0
        )
        AS
        BEGIN
            IF(@flag = 0)
            BEGIN
                SELECT DISTINCT MN.menu_Name, MN.menu_Id, MN.menu_ToPage 
                FROM tbl_Menu M
                LEFT JOIN Tbl_Menu MN ON M.menu_Id = MN.menu_ParentId
                LEFT JOIN Tbl_Menu MNU ON MN.menu_Id = MNU.menu_ParentId
                WHERE M.menu_Name = ''Exam''
                
                UNION
                
                SELECT DISTINCT MNU.menu_Name, MNU.menu_Id, MNU.menu_ToPage 
                FROM tbl_Menu M
                LEFT JOIN Tbl_Menu MN ON M.menu_Id = MN.menu_ParentId
                LEFT JOIN Tbl_Menu MNU ON MN.menu_Id = MNU.menu_ParentId
                WHERE M.menu_Name = ''Exam'' AND MNU.menu_Id IS NOT NULL
                ORDER BY menu_Name
            END
            
            IF(@flag = 1)
            BEGIN
                SELECT BL.Description, EP.Buttonstatus, BL.Button_Id, EB.Page_ButtonId, EB.Page_Id
                FROM Tbl_ExamButtonList EB
                INNER JOIN Tbl_ButtonList BL ON EB.Page_ButtonId = BL.Button_Id
                INNER JOIN Tbl_ExamAccessPrivilage EP ON EP.Page_Id = EB.Page_Id AND EP.Button_Id = EB.Page_ButtonId
                WHERE EB.Page_Id = @Page_Id
            END
            
            IF(@flag = 2)
            BEGIN
                SELECT BL.Description, EP.Buttonstatus, BL.Button_Id, EB.Page_ButtonId, EB.Page_Id
                FROM Tbl_ExamButtonList EB
                INNER JOIN Tbl_ButtonList BL ON EB.Page_ButtonId = BL.Button_Id
                INNER JOIN Tbl_ExamAccessPrivilage EP ON EP.Page_Id = EB.Page_Id AND EP.Button_Id = EB.Page_ButtonId
                WHERE Role_id = @roleid AND EB.Page_Id = @Page_Id AND EP.Button_Id = @Button_Id
            END
            
            IF(@flag = 3)
            BEGIN
                INSERT INTO Tbl_ExamAccessPrivilage (Page_Id, Button_Id, Buttonstatus, Role_Id, Created_Date, Delete_Status)
                VALUES (@List_Id, @Button_Id, @Buttonstatus, @roleid, GETDATE(), 0)
            END
            
            IF(@flag = 4)
            BEGIN
                DELETE FROM Tbl_ExamAccessPrivilage 
                WHERE Role_Id = @roleid AND Page_Id = @List_Id
            END
            
            IF(@flag = 5)
            BEGIN
                SELECT DISTINCT BL.Description, EP.Buttonstatus, BL.Button_Id, EB.Page_ButtonId, EB.Page_Id
                FROM Tbl_ExamButtonList EB
                INNER JOIN Tbl_ButtonList BL ON EB.Page_ButtonId = BL.Button_Id
                LEFT JOIN Tbl_ExamAccessPrivilage EP ON EP.Page_Id = EB.Page_Id AND EP.Button_Id = EB.Page_ButtonId
                WHERE Role_id = @roleid AND EB.Page_Id = @Page_Id
                ORDER BY BL.Description
            END
            
            IF(@flag = 6)
            BEGIN
                SELECT DISTINCT BL.Description, BL.Button_Id, EB.Page_ButtonId, EB.Page_Id
                FROM Tbl_ExamButtonList EB
                INNER JOIN Tbl_ButtonList BL ON EB.Page_ButtonId = BL.Button_Id
                WHERE EB.Page_Id = @Page_Id
                ORDER BY BL.Description
            END
            
            IF(@flag = 7)
            BEGIN
                SELECT DISTINCT M.menu_Name, M.menu_Id, M.menu_ToPage
                FROM tbl_Menu M
                WHERE M.menu_ParentId = 0
                ORDER BY menu_Name
            END
            
            IF(@flag = 8)
            BEGIN
                SELECT DISTINCT MN.menu_Name, MN.menu_Id, MN.menu_ToPage 
                FROM tbl_Menu M
                LEFT JOIN Tbl_Menu MN ON M.menu_Id = MN.menu_ParentId
                LEFT JOIN Tbl_Menu MNU ON MN.menu_Id = MNU.menu_ParentId
                WHERE M.menu_Id = @Button_Id AND MN.menu_Id IS NOT NULL
                
                UNION
                
                SELECT DISTINCT MNU.menu_Name, MNU.menu_Id, MNU.menu_ToPage 
                FROM tbl_Menu M
                LEFT JOIN Tbl_Menu MN ON M.menu_Id = MN.menu_ParentId
                LEFT JOIN Tbl_Menu MNU ON MN.menu_Id = MNU.menu_ParentId
                WHERE M.menu_Id = @Button_Id AND MNU.menu_Id IS NOT NULL
                ORDER BY menu_Name
            END
        END
    ')
END
