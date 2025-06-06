IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertPermanentformaddstudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_InsertPermanentformaddstudents]
    @allstudent_id bigint,
    @createdby_id bigint,
    @selectedfacultyids varchar(150),
    @selectedintakeids varchar(150),
    @Permanent_FormId bigint ,
    @selectedprogramids varchar(150),
    @selectedstudents varchar(150)
AS
BEGIN

    INSERT INTO tbl_PermanentFormAddStudent (
        Permanent_FormId,
        Student_Id,
        Faculty_Id,
        Programm_Id,
        Intake_Id,
        PermanentStdCreatedDate,        
        DelStatus,
        CreatedBy,
        SelectAllStudent


    )
    VALUES (
        @Permanent_FormId,
        526,
        @selectedfacultyids,
        @selectedprogramids,
        @selectedintakeids,
        GETDATE(),
        0,
        @createdby_id,
    
       @allstudent_id
    )
END
   ')
END;
