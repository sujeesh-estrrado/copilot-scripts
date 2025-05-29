IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_NoticeBoard]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_NoticeBoard]                          
(@Faculty varchar(50),@StudentName varchar(100),                        
@Program varchar(10),@Createdate datetime,                          
 @Intake varchar(100),@EmployeeName varchar(100),@Department varchar(100),                         
@Role varchar(100),@Subject varchar(100),@Annoncement varchar(Max),@Notice_Doc varchar(max),@Selectallstudents bigint,@Selectallemployee bigint,@notifyemail bigint,@notifywhatsapp bigint,@notifysms bigint,@notifyurgent bigint,@selectedstd bigint,@selectedemp bigint,@noticecreated bigint,@externallink varchar(max) )

AS 

BEGIN 
insert into dbo.tbl_Notice_Board(Faculty,Program,Intake,StudentName,Department,Role,EmployeeName,Subject,Annoncement,Notice_Doc,Createdate,Select_All_Students,Select_All_Employee,Notify_Email,Notify_Sms,Notify_Watsapp,Notify_Urgently,Selected_Students,Selected_Employee,Notice_Created,External_Link)
values(@Faculty,@Program,@Intake,@StudentName,@Department,@Role,@EmployeeName,@Subject,@Annoncement,@Notice_Doc,@Createdate,@Selectallstudents,@Selectallemployee,@notifyemail,@notifywhatsapp,@notifysms,@notifyurgent,@selectedstd,@selectedemp,@noticecreated,@externallink);

select SCOPE_IDENTITY()
end
   ');
END;
