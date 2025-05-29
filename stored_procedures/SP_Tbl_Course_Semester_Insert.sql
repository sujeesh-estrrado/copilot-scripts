IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Semester_Insert]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Tbl_Course_Semester_Insert]   -- ''SEM61'',''Year 1''
@Semester_Code varchar(50),
@Semester_Name varchar(200)
AS
begin
IF EXISTS(SELECT * FROM Tbl_Course_Semester Where (Semester_Name = @Semester_Name and Semester_Code=@Semester_Code) and Semester_DelStatus=0   )

BEGIN
    RAISERROR (''Data Already Exists.'', -- Message text.
                  16, -- Severity.
                  1 -- State.
                  );
END
ELSE   if not exists  (SELECT Semester_Name FROM Tbl_Course_Semester Where (Semester_Name = @Semester_Name and Semester_Code=@Semester_Code) and Semester_DelStatus=1   )
BEGIN
INSERT INTO [Tbl_Course_Semester]
          ([Semester_Code]
          ,[Semester_Name])
    VALUES
          (@Semester_Code
          ,@Semester_Name)
END

else
begin

update Tbl_Course_Semester set Semester_DelStatus=0 where Semester_Name = @Semester_Name and Semester_Code=@Semester_Code

end
end
--select * from Tbl_Course_Semester
    ')
END
GO