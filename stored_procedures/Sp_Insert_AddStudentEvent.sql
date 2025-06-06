IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_AddStudentEvent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Insert_AddStudentEvent]
@allstudent_id bigint,
@createdby_id bigint,
@selectedfacultyids varchar(150),
@selectedintakeids varchar(150),
@selecteEventId bigint,
@selectedprogramids varchar(150),
@selectedstudents varchar(150)
as
begin 
insert into Tbl_EventStudent(Event_Id,Student_Id,Faculty_Id,Programm_Id,Intake_Id,CreatedDate,DelStatus,CreatedBy,SelectAllStudent)
values(@selecteEventId,@selectedstudents,@selectedfacultyids,@selectedprogramids,@selectedintakeids,GETDATE(),0,@createdby_id,@allstudent_id)
end

   ')
END;
