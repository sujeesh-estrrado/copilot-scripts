IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Return_Book_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Return_Book_By_Id]  
(  
@ReturnId bigint  
)  
  
as  
  
begin  
  
select RB.*,IB.*,RF.*, FD.* ,
Case When IB.Candidate_or_Employee=0 Then (C.Candidate_Fname+'' ''+C.Candidate_Mname+'' ''+C.Candidate_Lname)       
Else (E.Employee_FName+'' ''+E.Employee_LName) End As Name ,B.[Book_Title] ,  
Case When IB.Candidate_or_Employee=0 then(  
Select Student_Reg_No from dbo.Tbl_Student_Registration where Candidate_Id=IB.Candidate_Employee_Id) else  
  
(Select Employee_Id_Card_No from dbo.Tbl_Employee where Employee_Id=IB.Candidate_Employee_Id) END as IDNO  
   
  
  
 from   
  
dbo.Tbl_LMS_Return_Book RB left join dbo.Tbl_LMS_Issue_Book IB on RB.Issue_Book_Id=IB.Issue_Book_Id  
left join dbo.Tbl_LMS_Return_Fine RF on RF.Return_Book_Id=RB.Return_Book_Id  
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=IB.Candidate_Employee_Id      
LEFT JOIN Tbl_Employee E ON E.Employee_Id=IB.Candidate_Employee_Id  
LEFT JOIN Tbl_AddBooks B ON IB.Book_Id=B.Book_Id 
inner join Tbl_LMS_Fine_Details FD on RF.Fine_Master_Id = FD.Fine_Master_Id
where RB.Return_Book_Id=@ReturnId  
  
end
');
END;
