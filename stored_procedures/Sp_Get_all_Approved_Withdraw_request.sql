IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_Approved_Withdraw_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_all_Approved_Withdraw_request] --''Termination''    
(@type varchar(500)='''')    
as    
begin    
--SELECT   distinct(Tbl_admission_approval_request.Approval_id),Tbl_Candidate_Personal_Det.Candidate_Id,dbo.Tbl_Course_Level.Course_Level_Name,concat( dbo.Tbl_Candidate_Personal_Det.Candidate_Fname,'' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) as C
  
    
    
    
    
--andidate_Name, dbo.Tbl_Student_Tc_request.Create_date,     
--                         dbo.Tbl_admission_approval_request.Remark,CONCAT( dbo.Tbl_Employee.Employee_FName,'' '', dbo.Tbl_Employee.Employee_LName) AS admission, concat(Tbl_Employee_1.Employee_FName ,''  '',Tbl_Employee_1.Employee_LName) AS finance,     
--                         dbo.Approval_Request.ApprovalRemark, dbo.Tbl_Candidate_Personal_Det.Candidate_Id AS ID,CC.Candidate_Email as email, dbo.Approval_Request_Type.Types as Request_type    
--FROM            dbo.Tbl_Employee_User INNER JOIN    
--                         dbo.Tbl_Course_Level INNER JOIN    
--                         dbo.Approval_Request INNER JOIN    
--                         dbo.Approval_Request_Type ON dbo.Approval_Request.RequestTypeId = dbo.Approval_Request_Type.Id INNER JOIN    
--                         dbo.Tbl_Student_Tc_request INNER JOIN    
--                         dbo.Tbl_Candidate_Personal_Det ON dbo.Tbl_Student_Tc_request.Candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id ON dbo.Approval_Request.StudentId = dbo.Tbl_Student_Tc_request.Candidate_id INNER JOIN    
--       Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=Tbl_Candidate_Personal_Det.Candidate_Id inner join    
--                         dbo.Tbl_admission_approval_request ON dbo.Tbl_Student_Tc_request.Candidate_id = dbo.Tbl_admission_approval_request.candidate_id ON     
--                         dbo.Tbl_Course_Level.Course_Level_Id = dbo.Tbl_Student_Tc_request.Faculty_id ON dbo.Tbl_Employee_User.User_Id = dbo.Tbl_admission_approval_request.Approved_By INNER JOIN    
--                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id left JOIN    
--                         dbo.Tbl_Employee_User AS Tbl_Employee_User_1 ON dbo.Approval_Request.ApprovalBy = Tbl_Employee_User_1.User_Id left JOIN    
--                         dbo.Tbl_Employee AS Tbl_Employee_1 ON Tbl_Employee_User_1.Employee_Id = Tbl_Employee_1.Employee_Id     
--       where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0 and dbo.Approval_Request_Type.Types=@type and Tbl_Student_Tc_request.Delete_status=0    
         
         
--SELECT DISTINCT ( ST.tc_request_id),    
--                         dbo.Tbl_Candidate_Personal_Det.Candidate_Id as ID, CC.Candidate_Email AS email, dbo.Approval_Request_Type.Types as Request_type, dbo.Tbl_admission_approval_request.candidate_id AS ID,     
--                         dbo.Tbl_admission_approval_request.Approval_id, dbo.Tbl_admission_approval_request.Verification_status AS Status, dbo.Tbl_admission_approval_request.create_date AS date,     
--                        CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname)  AS Candidate_Name, dbo.Tbl_Course_Level.Course_Level_Name    
--FROM            dbo.Tbl_admission_approval_request INNER JOIN    
--                         dbo.Approval_Request_Type ON dbo.Tbl_admission_approval_request.approval_type = dbo.Approval_Request_Type.Id left JOIN    
--                         dbo.Tbl_Candidate_Personal_Det ON dbo.Tbl_admission_approval_request.candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id left JOIN    
--                         dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id left JOIN    
--                         dbo.Tbl_Student_Tc_request AS ST ON ST.Candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id and Tbl_admission_approval_request.request_id=ST.tc_request_id and ST.delete_status=0 left JOIN    
--                         dbo.tbl_New_Admission ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id left JOIN    
--                         dbo.Tbl_Course_Level ON dbo.tbl_New_Admission.Course_Level_Id = dbo.Tbl_Course_Level.Course_Level_Id where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0     
--       --and Tbl_admission_approval_request.Verification_status=''Approved''     
--        and dbo.Approval_Request_Type.Types=@type and ST.Delete_status=0    
  
  
  
SELECT DISTINCT ( ST.tc_request_id),    
                         dbo.Tbl_Candidate_Personal_Det.Candidate_Id as ID, CC.Candidate_Email AS email, dbo.Approval_Request_Type.Types as Request_type, dbo.Tbl_admission_approval_request.candidate_id AS ID,     
                         dbo.Tbl_admission_approval_request.Approval_id, dbo.Tbl_admission_approval_request.Verification_status AS Status, dbo.Tbl_admission_approval_request.create_date AS date,     
                        CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname)  AS Candidate_Name, dbo.Tbl_Course_Level.Course_Level_Name    
FROM          Tbl_Student_Tc_request  ST   INNER JOIN    
                         dbo.Approval_Request_Type ON ST.Request_type = dbo.Approval_Request_Type.Types left JOIN    
                         dbo.Tbl_Candidate_Personal_Det ON ST.candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id left JOIN    
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id left JOIN    
                         dbo.Tbl_admission_approval_request ON ST.Candidate_id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id and Tbl_admission_approval_request.request_id=ST.tc_request_id and ST.delete_status=0 left JOIN    
                         dbo.tbl_New_Admission ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id left JOIN    
                         dbo.Tbl_Course_Level ON dbo.tbl_New_Admission.Course_Level_Id = dbo.Tbl_Course_Level.Course_Level_Id where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0    
       and dbo.Approval_Request_Type.Types=@type and ST.Delete_status=0   
       end    
    
    
    
    
    
--select * from Tbl_Student_Tc_request  
    ');
END;
