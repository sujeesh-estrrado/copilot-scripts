IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp.Insert_NoticeBoard]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp.Insert_NoticeBoard]
        (
            @Faculty VARCHAR(50),
            @StudentName VARCHAR(100),
            @Program VARCHAR(10),
            @Createdate DATETIME,
            @Intake VARCHAR(100),
            @EmployeeName VARCHAR(100),
            @Department VARCHAR(100),
            @Role VARCHAR(100),
            @Subject VARCHAR(100),
            @Annoncement VARCHAR(100),
            @Notice_Doc VARCHAR(MAX)
        )
        AS
        BEGIN
            INSERT INTO dbo.tbl_Notice_Board
            (
                Faculty,
                Program,
                Intake,
                StudentName,
                Department,
                Role,
                EmployeeName,
                Subject,
                Annoncement,
                Notice_Doc,
                Createdate
            )
            VALUES
            (
                @Faculty,
                @Program,
                @Intake,
                @StudentName,
                @Department,
                @Role,
                @EmployeeName,
                @Subject,
                @Annoncement,
                @Notice_Doc,
                @Createdate
            );

            SELECT SCOPE_IDENTITY();
        END
    ')
END
