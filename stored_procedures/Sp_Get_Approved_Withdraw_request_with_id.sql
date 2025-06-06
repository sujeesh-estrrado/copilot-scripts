IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Approved_Withdraw_request_with_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_Approved_Withdraw_request_with_id]

 --[Sp_Get_Approved_Withdraw_request_with_id] 40609,''Defer''  
(@candidate_id bigint,  
@type varchar(500)='''')  
as  
begin  
--SELECT     distinct ( dbo.Tbl_Student_Tc_request.Tc_request_id),   dbo.Tbl_Course_Level.Course_Level_Name,concat( dbo.Tbl_Candidate_Personal_Det.Candidate_Fname,'' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) as Candidate_Name, dbo.Tbl_Student_Tc_r
  
  
  
  
  
  
  
  
  
  
--equest.Create_date,   
--                         dbo.Tbl_admission_approval_request.Remark,CONCAT( dbo.Tbl_Employee.Employee_FName,'' '', dbo.Tbl_Employee.Employee_LName) AS admission, concat(Tbl_Employee_1.Employee_FName ,''  '',Tbl_Employee_1.Employee_LName) AS finance,   
--                         dbo.Approval_Request.ApprovalRemark, dbo.Tbl_Candidate_Personal_Det.Candidate_Id AS ID,CC.Candidate_Email as email,Tbl_admission_approval_request.verification_status as admissionStatus,Tbl_Student_Tc_request.remark as faculty_re
  
  
  
  
  
  
  
  
  
  
--mark,  
--       CONCAT( empfac.Employee_FName,'' '', empfac.Employee_LName) AS Facultydean,SA.Student_remark as appeal,SA.appeal_status,SA.create_date as appealdate  
--FROM            dbo.Tbl_Employee_User left JOIN  
--                         dbo.Tbl_Course_Level left JOIN  
--                         dbo.Approval_Request left JOIN  
--                         dbo.Approval_Request_Type ON dbo.Approval_Request.RequestTypeId = dbo.Approval_Request_Type.Id left JOIN  
--                         dbo.Tbl_Student_Tc_request left JOIN  
--                         dbo.Tbl_Candidate_Personal_Det ON dbo.Tbl_Student_Tc_request.Candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id ON dbo.Approval_Request.StudentId = dbo.Tbl_Student_Tc_request.Candidate_id left JOIN  
--       Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=Tbl_Candidate_Personal_Det.Candidate_Id left join  
--                         dbo.Tbl_admission_approval_request ON dbo.Tbl_Student_Tc_request.Candidate_id = dbo.Tbl_admission_approval_request.candidate_id ON   
--                         dbo.Tbl_Course_Level.Course_Level_Id = dbo.Tbl_Student_Tc_request.Faculty_id ON dbo.Tbl_Employee_User.User_Id = dbo.Tbl_admission_approval_request.Approved_By left JOIN  
--                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id left JOIN  
--                         dbo.Tbl_Employee_User AS Tbl_Employee_User_1 ON dbo.Approval_Request.ApprovalBy = Tbl_Employee_User_1.User_Id left JOIN  
--                         dbo.Tbl_Employee AS Tbl_Employee_1 ON Tbl_Employee_User_1.Employee_Id = Tbl_Employee_1.Employee_Id  
--       left join tbl_student_appeal as SA on SA.Candidate_id=Tbl_Candidate_Personal_Det.candidate_id and  SA.delete_status=0  
--       left join Tbl_Employee empfac on empfac.Employee_Id=Tbl_Course_Level.Faculty_dean_id  
--        where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0 and Tbl_Candidate_Personal_Det.Candidate_Id=40173 and Tbl_Student_Tc_request.Delete_status=0  
        
      SELECT     distinct ( STR.Tc_request_id),   dbo.Tbl_Course_Level.Course_Level_Name,concat( CPD.Candidate_Fname,'' '', CPD.Candidate_Lname) as Candidate_Name, STR.Create_date,   
                        case when dbo.Tbl_admission_approval_request.Remark='''' then ''-NA-'' else dbo.Tbl_admission_approval_request.Remark end as Remark ,case when CONCAT( dbo.Tbl_Employee.Employee_FName,'' '', dbo.Tbl_Employee.Employee_LName)='''' then ''-NA-''
  
 else  CONCAT( dbo.Tbl_Employee.Employee_FName,'' '', dbo.Tbl_Employee.Employee_LName) end  AS admission,  
       case when  concat(Tbl_Employee_1.Employee_FName ,''  '',Tbl_Employee_1.Employee_LName) = '''' then ''Admin'' else  concat(Tbl_Employee_1.Employee_FName ,''  '',Tbl_Employee_1.Employee_LName) end AS finance,  
       Approval_Request.ApprovalStatus as finance_status,  
                         dbo.Approval_Request.ApprovalRemark, CPD.Candidate_Id AS ID,CC.Candidate_Email as email,Tbl_admission_approval_request.verification_status as admissionStatus,STR.faculty_remark as faculty_remark,  
       CONCAT( empfac.Employee_FName,'' '', empfac.Employee_LName) AS Facultydean,SA.Student_remark as appeal,SA.appeal_status,SA.create_date as appealdate   
       from  Tbl_Student_Tc_request STR  
left join Tbl_Candidate_Personal_Det CPD on CPD.candidate_id=STR.candidate_id  
                     left join     dbo.Approval_Request_Type ON STR.Request_type = dbo.Approval_Request_Type.Types   
left join dbo.Approval_Request on Approval_Request.studentid=STR.Candidate_id and STR.Finance_approval_requestID=Approval_Request.RequestId left JOIN  
 Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=CPD.Candidate_Id  
left join   dbo.Tbl_admission_approval_request ON STR.Candidate_id = dbo.Tbl_admission_approval_request.candidate_id
and Tbl_admission_approval_request.approval_type=Approval_Request_Type.Id
and Tbl_admission_approval_request.request_id=STR.tc_request_id 
  
  
   
   
  
 left join  
 dbo.Tbl_Employee_User EU on EU.user_id= Tbl_admission_approval_request.Approved_by and EU.User_Id = dbo.Tbl_admission_approval_request.Approved_By  left JOIN  
 Tbl_Course_Level on dbo.Tbl_Course_Level.Course_Level_Id = STR.Faculty_id   
 left join  dbo.Tbl_Employee ON EU.Employee_Id = dbo.Tbl_Employee.Employee_Id left JOIN  
                         dbo.Tbl_Employee_User AS Tbl_Employee_User_1 ON dbo.Approval_Request.ApprovalBy = Tbl_Employee_User_1.User_Id left JOIN  
                         dbo.Tbl_Employee AS Tbl_Employee_1 ON Tbl_Employee_User_1.Employee_Id = Tbl_Employee_1.Employee_Id  
       left join tbl_student_appeal as SA on SA.Candidate_id=CPD.candidate_id and SA.Request_id=STR.Tc_request_id and  SA.delete_status=0 and STR.Delete_status=0  
       left join Tbl_Employee empfac on empfac.Employee_Id=Tbl_Course_Level.Faculty_dean_id   
       where CPD.Candidate_Id=@candidate_id and STR.Delete_status=0 and STR.request_type=@type  
         end  
  
  
  
  
  
     --  select * from  Approval_Request  
  
  
  
    ')
END
