IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAdmin_all_withdraw_request]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_GetAdmin_all_withdraw_request]--''Withdraw'',1434,0
(@Type varchar(max)='''',@id bigint=0,@flag bigint=0)
As
begin
if(@flag>0)
begin
SELECT     CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname)  AS Candidate_Name,D.Docname as doc,ST.Request_status,Employee_Id, ST.Request_status AS Status, CC.Candidate_Email, CPD.Candidate_Id AS ID,D.Path as url, CL.Course_Level_Name, 
FORMAT (ST.Create_date, ''dd-MM-yyyy, hh:mm:ss tt '')AS date,ST.Remark as Remark,ST.faculty_remark,
           Concat(dbo.Tbl_Employee.Employee_FName,'' '',dbo.Tbl_Employee.Employee_LName) as EmployeeName,cbd.Batch_Code as intake,De.Department_Name as courseName,CPD.adharnumber as icno,CPD.idmatrixno
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD INNER JOIN

                         dbo.Tbl_Student_Tc_request AS ST ON ST.Candidate_id = CPD.Candidate_Id INNER JOIN
                        
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = ST.Faculty_id 
                          left join tbl_new_admission N on N.new_admission_id=CPD.New_admission_id
                         left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=N.Batch_Id  
                         left join Tbl_Department De ON De.department_id=N.department_id
                         left JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = CPD.Candidate_Id left JOIN
                         dbo.Tbl_Employee ON CL.Faculty_dean_id = dbo.Tbl_Employee.Employee_Id
                         left join Tbl_Defer_Documents D on ST.Tc_request_id=D.Defer_Request_id and D.Candidate_id=CPD.Candidate_Id
where CPD.Candidate_DelStatus=0 and ST.Request_type=@Type    and ST.Delete_status=0 order by ST.Create_date

end
else
begin
SELECT     CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname)  AS Candidate_Name,D.Docname as doc,ST.Request_status,Employee_Id, ST.Request_status AS Status, CC.Candidate_Email, CPD.Candidate_Id AS ID,D.Path as url, CL.Course_Level_Name,
 FORMAT (ST.Create_date, ''dd-MM-yyyy, hh:mm:ss tt '') AS date,ST.Remark as Remark,ST.faculty_remark,
           Concat(dbo.Tbl_Employee.Employee_FName,'' '',dbo.Tbl_Employee.Employee_LName) as EmployeeName,cbd.Batch_Code as intake,De.Department_Name as courseName,CPD.adharnumber as icno,CPD.idmatrixno
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD INNER JOIN

                         dbo.Tbl_Student_Tc_request AS ST ON ST.Candidate_id = CPD.Candidate_Id INNER JOIN
                        
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = ST.Faculty_id 
                          left join tbl_new_admission N on N.new_admission_id=CPD.New_admission_id
                         left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=N.Batch_Id  
                         left join Tbl_Department De ON De.department_id=N.department_id
                         left JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = CPD.Candidate_Id left JOIN
                         dbo.Tbl_Employee ON CL.Faculty_dean_id = dbo.Tbl_Employee.Employee_Id
                         left join Tbl_Defer_Documents D on ST.Tc_request_id=D.Defer_Request_id and D.Candidate_id=CPD.Candidate_Id
where CPD.Candidate_DelStatus=0 and ST.Request_type=@Type and ST.Request_status!=''Approved'' and  ST.Delete_status=0   order by ST.Create_date ;
end
end
    ')
END
GO
